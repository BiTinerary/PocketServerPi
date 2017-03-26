#! /bin/sh

# All credits go to FergusL post on Armbian Forums (https://forum.armbian.com/index.php/topic/3515-nanopi-neo-air-access-point/?p=26591)
# Switch from station mode (client mode to a wifi network) to Acess Point mode for AP6212.
# Configuration of hostapd is found in /etc/hostapd/hostapd.conf or wherever the line "DAEMON_CONF" in /etc/default/hostapd points to.
# Do not forget to uncomment the line mentioned above in /etc/default/hostapd
# Edit /etc/network/interfaces with static IP for wlan0, example conf:
# auto wlan0
# iface wlan0 inet static
# 	address 192.168.101.1
# 	netmask 255.255.255.0
# 	dns-nameservers 192.168.101.1
# Configuration for DHCP server (using dnsmasq) is found in /etc/dnsmasq.conf, example conf:
# dhcp-range=192.168.101.20,192.168.101.120,72h
 
#TODO: Help, review and testers needed, especially for dealing with stopping/killing systemd services and process.
 
# Stop and disable nm. If it's enabled it locks at boot for 5 minutes.
# The dnsmasq processes aren't killed when nm stops and keep dhcp from working, kill them!
/bin/systemctl stop NetworkManager
/bin/systemctl disable NetworkManager
kill $(cat /var/run/NetworkManager/dnsmasq.pid)
kill $(cat /run/dnsmasq.br0.pid)
 
# Remove and re-add the wifi module, that time in AP mode
rmmod dhd
modprobe dhd op_mode=2
 
# Update symlinks for interfaces
rm /etc/network/interfaces
ln -s interfaces.hostapd /etc/network/interfaces
 
# Start using systemd and manually. Hostapd manages the interface, auth etc. and dnsmasq serves a DHCP server for clients connecting to the AP.
/bin/systemctl start hostapd
/usr/sbin/dnsmasq