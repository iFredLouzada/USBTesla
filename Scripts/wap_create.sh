#!/bin/bash
sudo apt --autoremove purge ifupdown -y
sudo rm -r /etc/network
sudo apt --autoremove purge dhcpcd5 -y
sudo apt --autoremove purge isc-dhcp-client isc-dhcp-common -y
sudo rm -r /etc/dhcp
sudo apt --autoremove purge rsyslog
sudo apt-mark hold ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog raspberrypi-net-mods openresolv
sudo systemctl enable systemd-networkd.service
sudo apt-get instll hostapd -y
sudo cat > /etc/hostapd/hostapd.conf <<EOF
driver=nl80211
ssid=USBTesla
country_code=CA
hw_mode=g
channel=1
auth_algs=1
wpa=2
wpa_passphrase=YourModelHere
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
