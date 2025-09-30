#!/bin/bash
# Created by Fred Louzada

## Tesla Sound Manager webapp

# Preparing to install the Flask interface management
echo "Installing WebApp for file management"

# Home into tesla wave manager diretory
sudo mkdir /home/pi/tesla-wave-mgmt/

# Creating web app directories
sudo mkdir /home/pi/tesla-wave-mgmt
sudo mkdir /home/pi/tesla-wave-mgmt/templates

# Downloading files
echo "Downloading template files and WebApp from GitHub"
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/app.py -O /home/pi/tesla-wave-mgmt/app.py
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/templates/base.html -O /home/pi/tesla-wave-mgmt/templates/base.html
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/templates/minimal.html -O /home/pi/tesla-wave-mgmt/templates/minimal.html
sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/refs/heads/main/tesla-wave-mgmt/templates/modern.html -O /home/pi/tesla-wave-mgmt/templates/modern.html

# Access directory and create .venv environment
cd /home/pi/tesla-wave-mgmt/
sudo python3 -m venv .venv

# Activate virtual enviroment
. .venv/bin/activate

# Instal Flask and SoundFile in virtual environmnet
sudo pip3 install flask
sudo pip3 install soundfile

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

# Enable and start the web app

echo "Enabling web interface"
sudo systemctl enable tesla-sound-manager
sudo systemctl start tesla-sound-manager
