#! /bin/sh

# All credits go to FergusL post on Armbian Forums (https://forum.armbian.com/index.php/topic/3515-nanopi-neo-air-access-point/?p=26591)
# Switch from Access Point mode to station mode (client mode to a wifi network) for AP6212.
 
#TODO: Help, review and testers needed, especially for dealing with stopping/killing systemd services and process.
 
# Stop running process for the AP
/bin/systemctl stop hostapd
kill $(cat /var/run/dnsmasq.pid)
 
# Remove and re-add the wifi module, that time in station mode.
rmmod dhd
modprobe dhd
 
# Update symlinks for interfaces
rm /etc/network/interfaces
ln -s interfaces.network-manager /etc/network/interfaces
 
# Start normal network services provided by NM.
/bin/systemctl start networking.service
/bin/systemctl enable NetworkManager
/bin/systemctl start NetworkManager
# NM needs to be told to use that interface again
/usr/bin/nmcli d set wlan0 managed yes
 
# Wait for wifi to come up and show a list of networks in range
sleep 8
/usr/bin/nmcli device wifi list