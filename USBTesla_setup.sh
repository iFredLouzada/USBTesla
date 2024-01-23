#!/bin/bash

# Update and Upgrade Raspberry Pi
echo "Updating and upgrading Raspberry Pi..."
sudo apt-get update

# Configure Raspberry Pi settings for USB gadget mode
# Enables the USB driver for gadget mode

echo "Configuring Raspberry Pi for USB gadget mode"
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt >/dev/null
echo "dwc2" | sudo tee -a /etc/modules >/dev/null

# Prompt the user for the size
# User has the ability to pick the size of storage

PS3="Select USB storage size (in GB): "
options=("4GB" "8GB" "16GB")
select size_option in "${options[@]}"
do
  case $size_option in
    "4GB")
      file_size=4096  # 4GB in megabytes
      break
      ;;
    "8GB")
      file_size=8192  # 8GB in megabytes
      break
      ;;
    "16GB")
      file_size=16384  # 16GB in megabytes
      break
      ;;
    *)
      echo "Invalid option, please select a valid size."
      ;;
  esac
done

# Creating the storage area based on selected size

echo "Creating and formatting the USB storage file (Size: $size_option) "
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=$file_size status=progress
sudo mkdosfs /piusb.bin -F 32 -I

# Create mount point and update fstab

echo "Creating mount point and updating fstab"
sudo mkdir /mnt/usb_share
echo "/piusb.bin /mnt/usb_share vfat users,umask=000 0 2" | sudo tee -a /etc/fstab >/dev/null
sudo mount -a
sync

# Enable mass storage device
sudo modprobe g_mass_storage file=/piusb.bin stall=0 ro=1

# Install the watchdog library
echo "Installing the watchdog library"
sudo apt-get install pip -y
sudo pip3 install watchdog

# Download the usb_share.py script
echo "Downloading the usb_share.py script..."
sudo wget http://rpf.io/usbzw -O /usr/local/share/usb_share.py
sudo chmod +x /usr/local/share/usb_share.py

# Create a systemd service unit file for usbshare
echo "Creating systemd service unit file for usbshare"

sudo tee /etc/systemd/system/usbshare.service > /dev/null <<EOL
[Unit]
Description=USB Share Watchdog

[Service]
Type=simple
ExecStart=/usr/local/share/usb_share.py
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and enable/start the usbshare service
echo "Reloading systemd..."
sudo systemctl daemon-reload
echo "Enabling and starting the usbshare service..."
sudo systemctl enable usbshare.service
sudo systemctl start usbshare.service

echo "USB Share Watchdog setup complete."

# Install Filebrowser
echo "Installing Filebrowser..."
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Create Filebrowser systemd service file
echo "Creating Filebrowser systemd service file..."
sudo bash -c 'cat << EOF > /etc/systemd/system/filebrowser.service
[Unit]
Description=File Browser
After=network.target

[Service]
ExecStart=filebrowser -r /mnt/usb_share -p 80 -a 0.0.0.0 -d /home/pi/database.db

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd and enable/start Filebrowser service
echo "Enabling and starting Filebrowser service..."
sudo systemctl daemon-reload
sudo systemctl enable filebrowser.service
sudo systemctl start filebrowser.service



# Message for the user
PI_IP=$(hostname -I | awk '{print $1}')
PI_HOSTNAME=$(hostname)

echo "Setup complete. You can access Filebrowser by opening a web browser and visiting the following URL:"
echo "Using IP address: http://${PI_IP}"
echo "Using hostname: http://${PI_HOSTNAME}.local"
echo "The default username is 'admin' and the default password is 'admin'."

