#!/bin/bash

# Update package lists
sudo apt-get update

# Install required packages
sudo apt-get install hostapd dnsmasq -y

# Configure hostapd
sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOL
interface=wlan0
ssid=USBTesla
wpa_passphrase=TrackMode1$
driver=nl80211
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

# Configure hostapd default file
sudo tee -a /etc/default/hostapd > /dev/null <<EOL
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOL

# Configure dnsmasq
sudo tee /etc/dnsmasq.d/access-point.conf > /dev/null <<EOL
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOL

# Configure dhcpcd
sudo tee -a /etc/dhcpcd.conf > /dev/null <<EOL
interface=wlan0
static ip_address=192.168.4.1/24
nohook wpa_supplicant
EOL

# Enable IP forwarding
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

# Set up NAT
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o wlan0:1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0:1 -o wlan0 -j ACCEPT

# Save iptables rules
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

# Configure rc.local
sudo tee /etc/rc.local > /dev/null <<EOL
#!/bin/sh -e
iptables-restore < /etc/iptables.ipv4.nat
exit 0
EOL

# Make rc.local executable
sudo chmod +x /etc/rc.local

# Start services
sudo systemctl start hostapd
sudo systemctl enable hostapd
sudo systemctl start dnsmasq
sudo systemctl enable dnsmasq

# Reboot to apply changes
sudo reboot
