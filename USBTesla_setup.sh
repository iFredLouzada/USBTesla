#!/bin/bash
# Created by Fred Louzada

## Run the installer: 
## bash -c "$(curl -fsSL https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/USBTesla_setup.sh)"

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
echo "Sit back and relax, depending on the size you picked this might take some time ..."
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=$file_size status=progress
sudo mkdosfs /piusb.bin -F 32 -I

# Update Raspberry Pi for good luck
echo "Updating and upgrading Raspberry Pi..."
sudo apt-get update

# Install the watchdog library
echo "Installing the watchdog library"
sudo apt-get install pip -y
sudo pip3 install watchdog
sudo apt-get install git -y

# Download the usb_share.py script
echo "Downloading the usb_share.py script..."
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/usb_share.py -O /usr/local/share/usb_share.py
sudo chmod +x /usr/local/share/usb_share.py

# Configure Raspberry Pi settings for USB gadget mode
# Enables the USB driver for gadget mode
echo "Configuring Raspberry Pi for USB gadget mode"
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt >/dev/null
echo "dwc2" | sudo tee -a /etc/modules >/dev/null

# Create mount point and update fstab

echo "Creating mount point and updating fstab"
sudo mkdir /mnt/usb_share
echo "/piusb.bin /mnt/usb_share vfat users,umask=000 0 2" | sudo tee -a /etc/fstab >/dev/null
sudo mount -a
wget get -P /mnt/usb_share https://github.com/iFredLouzada/USBTesla/raw/main/LockChime.wav
sync

# Enable mass storage device
#sudo modprobe g_mass_storage file=/piusb.bin stall=0 ro=1

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
ExecStart=filebrowser -r /mnt/usb_share -p 8080 -a 0.0.0.0 -d /home/pi/database.db

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd and enable/start Filebrowser service
echo "Enabling and starting Filebrowser service..."
sudo systemctl daemon-reload
sudo systemctl enable filebrowser.service
sudo systemctl start filebrowser.service

# Create routine to install the Wifi portion of it
echo "Setting Locale to CA"
sudo raspi-config nonint do_wifi_country CA
sleep 3

echo "Downloading and installing Autohotspot script"
curl "https://www.raspberryconnect.com/images/hsinstaller/Autohotspot-Setup.tar.xz" -o AutoHotspot-Setup.tar.xz
tar xf AutoHotspot-Setup.tar.xz
cd Autohotspot
sudo ./autohotspot-setup.sh

# 1 = Install Autohotspot with eth0 access for Connected Devices
# 2 = Install Autohotspot with No eth0 for connected devices  
# 3 = Install a Permanent Access Point with eth0 access for connected devices
# 4 = Uninstall Autohotspot or permanent access point
# 5 = Add a new wifi network to the Pi (SSID) or update the password for an existing one
# 6 = Autohotspot: Force to an access point or connect to WiFi network if a known SSID is in range
# 7 = Change the access points SSID and password
# 8 = Exit

# Let's play keystrokes!!
(
echo "2"
sleep 1
echo ""
sleep 1
echo ""
sleep 1
echo "7"
sleep 1
echo "USBTesla"
sleep 1
echo "Plaid2022"
sleep 1
echo ""
sleep 1
echo "8"
) | sudo ./autohotspot-setup.sh

# Preparing to install the Flask interface management
echo "Installing WebApp for file management"

cd ..
mkdir tesla-wave-mgmt
cd tesla-wave-mgmt
python3 -m venv .venv
. .venv/bin/activate
pip3 install soundfile

# Downloading files
echo "Downloading template files and WebApp from GitHub"

sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/app.py -O app.py
mkdir templates
cd templates
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/templates/base.html -O base.html
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/templates/minimal.html -O minimal.html
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/templates/modern.html -O modern.html
cd ..

# Create a service file
echo "Creating a service file for auto start"

sudo bash -c 'cat << EOF > /etc/systemd/system/tesla-sound-manager.service
[Unit]
Description=Tesla Sound Manager
After=network.target

[Service]
User=pi
WorkingDirectory=/home/pi/tesla-wave-mgmt
Environment="PATH=/home/pi/tesla-wave-mgmt/.venv/bin"
ExecStart=/home/pi/tesla-wave-mgmt/.venv/bin/python3 app.py

[Install]
WantedBy=multi-user.target"
EOF'

# Create a service file
echo "Enabling web interface"

sudo systemctl enable tesla-sound-manager
sudo systemctl start tesla-sound-manager

# Message for the user
PI_IP=$(hostname -I | awk '{print $1}')
PI_HOSTNAME=$(hostname)
clear
echo "----------------------------------------------------------------------------------------------------------"
echo "You can access Filebrowser by opening a web browser and visiting the following URL:"
echo "Using IP address: http://${PI_IP}:8080"
echo "Using hostname: http://${PI_HOSTNAME}.local:8080"
echo "The default username is 'admin' and the default password is 'admin'."
echo "         "
echo "To access the web interface that manages which Lockchime file will be active, visit: "
echo "Using IP address: http://${PI_IP}"
echo "Using hostname: http://${PI_HOSTNAME}.local"
echo "Connecting from Tesla is not yet supported but in the works :)"
echo "----------------------------------------------------------------------------------------------------------"

# Start a 10-second countdown
echo "Rebooting the Raspberry Pi in 10 seconds, after reboot the pi will restart and come back as a usb storage device"
echo "Test that it works on your computer first before moving it to your car"

for ((i=10; i>=1; i--)); do
  echo "Countdown: $i seconds..."
  sleep 1
done

# Reboot the Raspberry Pi
echo "Rebooting now..."
sudo reboot
