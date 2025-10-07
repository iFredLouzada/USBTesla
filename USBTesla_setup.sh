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
echo "Creating and formatting the USB storage file (Size: $size_option)"
echo "Sit back and relax, depending on the size you picked this might take some time..."

# Try fallocate first (much faster)
if command -v fallocate &> /dev/null; then
    echo "Using fallocate to create storage file..."
    if ! sudo fallocate -l ${file_size}M /piusb.bin; then
        echo "fallocate failed, falling back to dd..."
        sudo dd bs=1M if=/dev/zero of=/piusb.bin count=$file_size status=progress
    fi
else
    # Fallback to dd if fallocate isn't available
    sudo dd bs=1M if=/dev/zero of=/piusb.bin count=$file_size status=progress
fi

# Check if file was created successfully
if [ ! -f /piusb.bin ]; then
    echo "Error: Failed to create storage file!"
    exit 1
fi

# Format the drive with a label
echo "Formatting storage file..."
sudo mkfs.vfat -F 32 -I /piusb.bin -n "USBDRIVE"

# Verify final size
actual_size=$(du -h /piusb.bin | cut -f1)
echo "USB storage file created successfully"
echo "Final file size: $actual_size"

# Update Raspberry Pi for good luck
echo "Updating and upgrading Raspberry Pi..."
sudo apt-get update

# Install the watchdog library
echo "Installing the watchdog library"
sudo apt-get install python3-pip -y
sudo apt-get install python3-venv -y
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



# Message for the user
PI_IP=$(hostname -I | awk '{print $1}')
PI_HOSTNAME=$(hostname)

echo "----------------------------------------------------------------------------------------------------------"
echo "You can access Filebrowser by opening a web browser and visiting the following URL:"
echo "Using IP address: http://${PI_IP}:8080"
echo "Using hostname: http://${PI_HOSTNAME}.local:8080"
echo "The default username is 'admin' and the default password is 'admin'."
echo "----------------------------------------------------------------------------------------------------------"