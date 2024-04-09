#!/bin/bash

# Update and Upgrade
sudo apt-get update -y
sudo apt-get upgrade -y

# Install requirements
sudo apt-get install hostapd -y
sudo apt-get install dnsmasq -y

# restart controls
sudo systemctl unmask hostapd
sudo systemctl disable hostapd
sudo systemctl disable dnsmasq


# Prompt the user for the desired SSID, pass and country code
read -p "Enter the desired SSID: " ssid
read -p "Enter the WPA passphrase: " wpa_passphrase
read -p "Enter the 2-letter country code (e.g., CA): " country_code

sudo cat > /etc/hostapd/hostapd.conf << EOF
#2.4GHz setup wifi 80211 b,g,n
interface=wlan0
driver=nl80211
ssid=$ssid
hw_mode=g
channel=8
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$wpa_passphrase
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP TKIP
rsn_pairwise=CCMP

#80211n - Change GB to your WiFi country code
country_code=$country_code
ieee80211n=1
ieee80211d=1
EOF

sudo cat > /etc/dnsmasq.conf << EOF
#AutoHotspot Config
#stop DNSmasq from using resolv.conf
no-resolv
#Interface to use
interface=wlan0
bind-interfaces
dhcp-range=10.0.0.50,10.0.0.150,12h
EOF

echo "nohook wpa_supplicant" >> /etc/dhcpcd.conf

sudo cat > /etc/systemd/system/autohotspot.service << EOF
[Unit]
Description=Automatically generates an internet Hotspot when a valid ssid is not in range
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/autohotspot

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable autohotspot.service

#retrieve file autohotspot.sh
# Download the usb_share.py script
#echo "Downloading the usb_share.py script..."
#sudo wget https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/usb_share.py -O /usr/local/share/usb_share.py
#sudo chmod +x /usr/local/share/usb_share.py

sudo chmod +x /usr/bin/autohotspot


