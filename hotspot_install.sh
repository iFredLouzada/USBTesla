#!/bin/bash
# Created by Fred Louzada

## Download and install AutoHotSpot

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





