#!/bin/bash
# Wrapper for RaspberryConnect.com's Autohotspot installer
# Automatically selects option 2 (Autohotspot with No eth0)

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Create temporary directory and move into it
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract the original package
echo "Downloading RaspberryConnect.com's Autohotspot installer..."
curl -fsSL "https://www.raspberryconnect.com/images/hsinstaller/Autohotspot-Setup.tar.xz" -o AutoHotspot-Setup.tar.xz
tar xf AutoHotspot-Setup.tar.xz
cd Autohotspot

# Install expect if not present
apt-get update
apt-get install -y expect > /dev/null 2>&1

# Create expect script to automate the selection
expect << 'EOF'
spawn ./autohotspot-setup.sh
expect "Select an Option:"
send "2\r"
expect "Press any key to continue"
send "\r"
expect "Select an Option:"
send "8\r"
expect eof
EOF

# Cleanup
cd
rm -rf "$TEMP_DIR"

echo "Autohotspot installation completed!"
echo "A reboot is recommended to complete the setup."