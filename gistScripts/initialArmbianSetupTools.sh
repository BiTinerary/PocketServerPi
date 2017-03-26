### Essentials
sudo su
apt-get update
apt-get upgrade
apt-get install python-pip

### Samba Share
apt-get install samba
sudo smbpasswd -a stuxnet # Change Variable
mkdir /home/stuxnet/samba # Change Variable 

cp /etc/samba/smb.conf ~
nano /etc/samba/smb.conf

## append the follow to end of file (EOF)
[stuxnet]
path = /home/stuxnet/samba # Change variables
valid users = root, stuxnet
read only = no
##

chown stuxnet /home/stuxnet/samba #Add/Edit/Execute files in/via SambaServer
service smbd restart
testparm

### PIL and PythonDev Tools
apt-get install python-dev python-setuptools
apt-get install libjpeg-dev

apt-get install wavemon
