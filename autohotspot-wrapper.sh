#!/bin/bash
# Wrapper for RaspberryConnect.com's Autohotspot installer
# Automatically selects option 2 (Autohotspot with No eth0)

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
sudo raspi-config nonint do_wifi_country CA

# Create temporary directory and move into it
TEMP_DIR="Autohotspot"

# Download and extract the original package
echo "Downloading RaspberryConnect.com's Autohotspot installer..."
sudo curl -fsSL "https://www.raspberryconnect.com/images/hsinstaller/Autohotspot-Setup.tar.xz" -o AutoHotspot-Setup.tar.xz
sudo tar xf AutoHotspot-Setup.tar.xz
cd $TEMP_DIR

# Install expect if not present
# sudo apt-get update
sudo apt-get install -y expect > /dev/null 2>&1

# Create expect script to automate the selection
sudo expect << 'EOF'
spawn ./autohotspot-setup.sh
expect "Select an Option:"
send "2\r"
expect "Press any key to continue"
send "\r"
expect "Select an Option:"
send "8\r"
expect eof
EOF

# Check if the first operation was successful
if [ $? -eq 0 ]; then
    echo "Autohotspot installation completed successfully"
    echo "Now configuring SSID and password..."
    
    # Second expect script: Change SSID and password
    sudo expect << 'EOF'
    spawn ./autohotspot-setup.sh
    expect "Select an Option:"
    send "7\r"
    expect "Enter the new Access Point SSID:"
    send "USBTesla\r"
    expect "Enter the hotspots new password. Minimum 8 characters"
    send "Plaid2024\r"
    expect "Press a key to continue"
    send "\r"
    expect "Select an Option:"
    send "8\r"
    expect eof
EOF
else
    echo "Error: Autohotspot installation failed"
    exit 1
fi

# Cleanup
cd
rm -rf "$TEMP_DIR"

clear
echo "Autohotspot installation and configuration completed!"
echo "SSID: USBTesla"
echo "Password: Plaid2024"
echo "A reboot is recommended to complete the setup."