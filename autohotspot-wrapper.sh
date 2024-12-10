#!/bin/bash
# Wrapper for RaspberryConnect.com's Autohotspot installer
# Automatically selects option 2 (Autohotspot with No eth0)

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Download the original script
echo "Downloading RaspberryConnect.com's Autohotspot installer..."
sudo curl -fsSL https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/autohotspot-setup.sh -o /tmp/autohotspot-setup.sh
sudo chmod +x /tmp/autohotspot-setup.sh

# Install expect if not present
sudo apt-get update
sudo apt-get install -y expect > /dev/null 2>&1

# Create expect script to automate the selection
sudo expect << 'EOF'
spawn /tmp/autohotspot-setup.sh
expect "Select an Option:"
send "2\r"
expect "Press any key to continue"
send "\r"
expect "Select an Option:"
send "8\r"
expect eof
EOF

# Cleanup
sudo rm /tmp/autohotspot-setup.sh

echo "Autohotspot installation completed!"