# PocketServerPi -- in progress --
A backup copy of my NanoPi Neo Air setup that I felt was worth documenting. More or less, my setup produces a portable proftpd, SSH, bluetooth media, minidlna, Access Point **and** samba server, etc.. rolled into one, for $30.

<img src='https://s18.postimg.org/4r4brjkd5/nano_Pi_OTG2.jpg'>
<img src="https://s16.postimg.org/yhsbsdlj9/IMG_1838.jpg">

##**Table of Contents**<br>
- [Build Materials](#build-materials)
- [Installation](#installation)
- [Tutorials](#tutorials)
  - [Wifi](#wifi)
  - [Basic Tools](#basic-cli-tools)
  - [Auto Swap WiFi AP/Client](#auto-swap-wifi-ap-and-client)
  - [Bluetooth](#bluetooth)
  - [GPIO](#gpio)
- [Proof Of Concept and Examples](#proof-of-concept-and-examples)

## Build Materials
* <a href='http://www.friendlyarm.com/index.php?route=product/product&product_id=151'>NanoPi Neo Air</a>: $17.99 + $8 Shipping<br>
My total cost after tax, shipping, hardware and a clear acrylic case [recommended for only $3.00] was $28.98
* <a href='https://www.amazon.com/gp/product/B01E0918J8/ref=oh_aui_detailpage_o02_s01?ie=UTF8&psc=1'>32gb UHS-I Lexar Micro SD Card</a>: <strike>$9.49</strike><br>
If you're buying a NanoPi Neo Air, then this probably isn't your first rodeo. Use an SD card you have lying around.
* <a href='http://www.taydaelectronics.com/bte13-007-cp2102-serial-converter-usb-2-0-to-ttl-uart-ftdi.html'>USB to UART Adapter</a>: $1.99<br>
I ordered 4-5 items in addition to 2 of these from <a href='http://www.taydaelectronics.com'>Tayda</a> and S&H was only $1.26.
* <a href='https://www.sparkfun.com/pages/RF_Conn_Guide'>U.FL (aka IPX) Antenna</a>: Cheap<br>
This was something I had on hand, from a previous OrangePi purchase, that wasn't utilizing Wifi. It's worth mentioning that the Neo Air **doesn't** include **any kind** of external **or** internal antenna. You **will** need one of these if you want WiFi.

## Installation
At the end of the day I prefer Armbian kernel and default setup. However, I reluctantly chose FriendlyArm's kernel since only their binaries and drivers support the 'Access Point' feature that plays a significant role in this project. Furthermore, Armbian forums mentioned multiple times that their kernel/drivers don't support an Access Point and "Nothing will ever improve."

Anyways, you know the drill. Here's FriendlyArm's link to <a href='https://www.mediafire.com/folder/sr5d0qpz774cs/NanoPi-NEO_Air'>download</a> images. Write to a MicroSD card using <a href='https://sourceforge.net/projects/win32diskimager/files/Archive/'>Win32 Disk Imager</a>. Put MicroSD into device, wait for LEDs to blink. From here you will need to make a serial connection between your computer and the Neo Air in order to communicate with it. If you are unfamiliar with that process, check out this <a href='https://gist.github.com/BiTinerary/5d759c5715c2432e9830842171f97c4c'>Gist</a>.

FriendlyArm's default credentials are as follows<br>
user:`root` password:`fa`<br>
user:`fa` password:`fa` (**not** a sudoer)<br>

I tinkered around with the 4GB image for a couple hours/days and I never was able to get the WiFi working on that image. By default, the `/etc/wpa_supplicant/wpa_supplicant.conf` doesn't exist on the 4GB version, also they mention specifically (not explicitly) to use the 8GB 'eFlasher' version to set up WiFi. With that in mind you can write the filesystem/image to the onboard NAND using:<br>

`flash_eMMC.sh -d /mnt/sdcard/Ubuntu-Core-qte/`

In case you were wondering, installing packages, editing files (with exception to some locations), etc... will **not** be carried over after you flash to the NAND. Also, upon a clean boot anytime you use `sudo` command you'll receive the error `sudo: unable to resolve host FriendlyARM`. To fix this, run:<br>

`echo $(hostname -I | cut -d\ -f1) $(hostname) | sudo tee -a /etc/hosts` [*](#credit)

## Tutorials

### Wifi
A major caveat (some might say benefit) to FriendlyArm is that it comes annoyingly bare. To the point where they suggest mounting the MicroSD card to an Ubuntu system (I had to use a VirtualBox with shared USB) in order to manually edit the ` etc/wpa_supplicant/wpa_supplicant.conf` so that you can get it online. You could just avoid that collosal work around and append the `wpa_supplicant.conf` with the proper setup, or use the CLI editor `vi` that it comes with. Here's a one liner to append a the file with the goods, just make sure to replace the SSID and PASSWORD strings for your own credentials.<br>

`touch /etc/wpa_supplicant/wpa_supplicant.conf`<br>
`echo -e 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\nupdate_config=1\nnetwork={\n\t ssid="YOUR-WIFI-ESSID"\n\t psk="YOUR-WIFI-PASSWORD"\n}' >> /etc/wpa_supplicant/wpa_supplicant.conf`

### Basic CLI Tools
I typically start with: `sudo apt-get install nano htop wavemon samba minidlna screen -y` and then go on to edit configs.

### Auto Swap WiFi AP and Client
Setup a cronjob in `crontab -e` to run the `cronLaunch.sh` (which in turn fires off the python `switchAPMode.py`) script on startup or reboot. It will always try to connect as client, using any/all credentials supplied in `wpa_supplicant` config. If after 3 failed attempts, over 30 seconds, the device fails to ping a specified remote server (in this case Google) then the device will run FriendlyArm's binary in order to turn on Access Point mode. From there, you can connect via phone, browser, etc... If you want it to turn back into a client and connect to a home or work network SSID, you will need to do so by manually running `turn-wifi-into-apmode no`

### Bluetooth
- <a href='https://gist.github.com/BiTinerary/f7129a98823d5a130607fc9a26d2d4c0'>This Gist</a><br>
or
- This tutorial that is confirmed to work: https://wiki.archlinux.org/index.php/Bluetooth_headset

### GPIO
They have zero public documentation (in english) for utilizing their GPIO at the moment. They said they will have an update in 2 weeks (from 12.8.16), so for the time being I plan on tinkering with sysfs and other wrappers, to see what is compatible.<br>

## Proof of Concept and Examples
SSH over HTTP/S using <a href='https://github.com/paradoxxxzero'>Paradoxxxzero</a>'s <a href='https://github.com/paradoxxxzero/butterfly'>Butterfly</a> and a Samba server connection using <a href='https://play.google.com/store/apps/details?id=com.metago.astro&hl=en'>Astro File Manager</a>, running on Android Lollipop v5.0.1<br>
<p align="center"><img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sshoverhttpviabutterfly.gif'>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sambaserverresize.gif"></p>

## Use case
~ A $30 version of this:<br> https://www.amazon.com/SanDisk-Wireless-Smartphones-Tablets-SDWS1-032G-A57/dp/B00DR8LAE2?th=1<br>
~ Consistant, Portable access to a Linux box or python terminal.<br>
~ Linux box that can be used as a disposable scratchpad.<br>
~ Painless and local (much safer) Samba Share for file sharing between work **and** home without ever touching a button<br>
~ Minidlna server for Consoles, Medial Players, etc...<br>
~ `if static ip present; do wakeonlan` ie: wireless, buttonless, IOT trigger.<br>
~ Captive portals<br>

## TODO
* Create a basic, generalized image (personal passwords/credz removed) so that USB to UART adapter is not needed for setup and can be accessed directly via SSH, Butterfly, Putty etc...
* Boot as HID device, extending the "swiss army knife" capabilities to Rubber Ducky territory.

## Credit
- Mr. Anderson's answer that didn't get enough credit, <a href='http://askubuntu.com/questions/59458/error-message-when-i-run-sudo-unable-to-resolve-host-none'>here</a>.
- This bluetooth tutorial: https://wiki.archlinux.org/index.php/Bluetooth_headset

