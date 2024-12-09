#!/bin/bash
# Created by Fred Louzada

## Tesla Sound Manager webapp

# Preparing to install the Flask interface management
echo "Installing WebApp for file management"

sudo mkdir /home/pi/tesla-wave-mgmt
cd /home/pi/tesla-wave-mgmt/
sudo python3 -m venv .venv
. .venv/bin/activate
sudo pip3 install Flask
sudo pip3 install soundfile

# Downloading files
echo "Downloading template files and WebApp from GitHub"

sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/app.py -O app.py
sudo mkdir /home/pi/tesla-wave-mgmt/templates
cd /home/pi/tesla-wave-mgmt/templates
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
