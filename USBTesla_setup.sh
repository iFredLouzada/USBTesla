#!/bin/bash

# Update and Upgrade Raspberry Pi
echo "Updating and upgrading Raspberry Pi..."
sudo apt-get update
sudo apt-get upgrade -y

# Configure Raspberry Pi settings for USB gadget mode
echo "Configuring Raspberry Pi for USB gadget mode..."
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
echo "dwc2" | sudo tee -a /etc/modules

# Create and format the USB storage file (1GB)
echo "Creating and formatting the USB storage file..."
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=1024
sudo mkdosfs /piusb.bin -F 32 -I

# Create mount point and update fstab
echo "Creating mount point and updating fstab..."
sudo mkdir /mnt/usb_share
echo "/piusb.bin /mnt/usb_share vfat users,umask=000 0 2" | sudo tee -a /etc/fstab
sudo mount -a

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
echo "Setup complete. You can access Filebrowser by opening a web browser and entering the Raspberry Pi's IP address followed by port 80 (e.g., http://<your_pi_ip>:80). The default username is 'admin' and the default password is 'admin'."
