# PocketServerPi
A backup copy of my NanoPi Neo Air setup, running FriendlyArm, that I felt was worth documenting. More or less, my setup produces a portable proftpd, SSH, bluetooth media, minidlna, Access Point **and** samba server, etc.. rolled into one, for $30.

<img src='https://s18.postimg.org/4r4brjkd5/nano_Pi_OTG2.jpg'>
<img src="https://s16.postimg.org/yhsbsdlj9/IMG_1838.jpg">

##**Table of Contents**<br>
- [Proof Of Concept and Examples](#proof-of-concept-and-examples)
- [Build Materials](#build-materials)
- [Installation](#installation)
- [Tutorials](#tutorials)
  - [Wifi](#wifi)
  - [Basic Tools](#basic-cli-tools)
  - [i2C Screen](#i2c-screen-ssd1306)
  - [Auto Swap WiFi AP/Client](#auto-swap-wifi-ap-and-client)
  - [Bluetooth](#bluetooth)
  - [GPIO](#gpio)

## Proof of Concept and Examples
SSH over HTTP/S using <a href='https://github.com/paradoxxxzero'>Paradoxxxzero</a>'s <a href='https://github.com/paradoxxxzero/butterfly'>Butterfly</a> and a Samba server connection using <a href='https://play.google.com/store/apps/details?id=com.metago.astro&hl=en'>Astro File Manager</a>, running on Android Lollipop v5.0.1<br>
<p align="center"><img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sshoverhttpviabutterfly.gif'>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sambaserverresize.gif"></p>

Run time on the portable Uline battery (2200mAh) seen in first pictures, was 4 hours 19 minutes.

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
At the end of the day I prefer Armbian kernel and default setup. However, I reluctantly chose FriendlyArm's kernel since their binaries/drivers/support for the 'Access Point' feature that plays a significant role in this project, worked out of the box. Mostly, I got the guy up and running and haven't gone back and put too much effort into testing Armbian support. I'm told AP Mode is supported though. Eventually, I will work my way backwards and provide a similar write up as this one to feature Armbian as the kernel. For now, you'll just have to wait or tinker on your own. In the meantime, FergusL was kind enough to make some bash scripts to switch Apmode in Armbian <a href='https://forum.armbian.com/index.php/topic/3515-nanopi-neo-air-access-point/?p=26591'>Here's</a> a link to that. I've also duplicated them to the following gists, in case the link/post goes bad and for personal quick reference. <a href='https://gist.github.com/BiTinerary/693b8949ed56d6c534d138b9ba2b837e#file-stamode-sh'>stamode.sh</a> & <a href='https://gist.github.com/BiTinerary/693b8949ed56d6c534d138b9ba2b837e#file-apmode-sh'>apmode.sh</a><br>
<br>
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
FriendlyArm suggests mounting the MicroSD card to an Ubuntu system (I had used a VirtualBox with shared USB) in order to manually edit the `/etc/wpa_supplicant/wpa_supplicant.conf` to get it to connect to an SSID. This is a crazy work around and can be done by just appending the `wpa_supplicant.conf` with the proper info. Or by using the CLI editor `vi` that it comes with. Here's a one liner to get you device to connect to your WiFi Network, just make sure to replace the SSID and PASSWORD strings for your own stuff.<br>

`echo -e 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\nupdate_config=1\nnetwork={\n\t ssid="YOUR-WIFI-ESSID"\n\t psk="YOUR-WIFI-PASSWORD"\n}' >> /etc/wpa_supplicant/wpa_supplicant.conf`

### Basic CLI Tools
I typically start with: `sudo apt-get install nano htop wavemon screen samba minidlna -y` and then go on to edit configs.<br>
  - <a href='https://help.ubuntu.com/community/How%20to%20Create%20a%20Network%20Share%20Via%20Samba%20Via%20CLI%20(Command-line%20interface/Linux%20Terminal)%20-%20Uncomplicated,%20Simple%20and%20Brief%20Way!'>Setup Samba</a> [*](#credit)
  - <a href='https://help.ubuntu.com/community/MiniDLNA'>Setup minidlna</a>

### i2c Screen SSD1306
<img src='https://s12.postimg.org/lawg9srv1/IMG_9943.jpg'><br>
<br>
Much easier than I anticipated. Here's the module I downloaded/followed. Give this guy some credit!<br> <a href='https://github.com/rm-hull/luma.oled'>https://github.com/rm-hull/luma.oled</a><br>
<br>
He has the full documentation, installation, example code here: <a href='https://luma-oled.readthedocs.io'>https://luma-oled.readthedocs.io</a><br>
Note that for the NanoPi NeoAir, the example code works, you just have to <b>change ports</b> `port=1` to `port=0`<br>
<a href='https://gist.github.com/BiTinerary/36be549f8bc5ff132914bf70743985d7'>Here's</a> my custom gist of the exact commands and script that I ran.<br>

When running a rendering script it claimed 56 FPS, however that can't be true. Through the `bubbles.py` test script and eye balling it, it's more around <b>15-20 FPS</b>.<br>
<br>
The same guy also provides example scripts (Bubbles, Clock, sys_info, etc...) which are located <a href='https://github.com/rm-hull/luma.examples'>here</a>.<br>
You run them like so... `sudo python bubbles.py --display ssd1306 --interface i2c --interface-port 0`<br>

### Auto Swap WiFi AP and Client
Setup a cronjob in `crontab -e` to run the `cronLaunch.sh` (which in turn fires off `switchAPMode.py`) script on startup. It will always try to connect as client, using any/all credentials supplied in `wpa_supplicant` config. If after 3 failed attempts, over 30 seconds, the device fails to ping a specified remote server (in this case Google) then the device will run FriendlyArm's binary in order to turn on Access Point mode. From there, you can connect via phone, browser, etc... If you want it to turn back into a client and connect to a home or work network SSID, you will need to do so by manually running `turn-wifi-into-apmode no` or by simply restarting.

### Bluetooth
- <a href='https://gist.github.com/BiTinerary/f7129a98823d5a130607fc9a26d2d4c0'>This Gist</a><br>
or
- This tutorial that is confirmed to work: https://wiki.archlinux.org/index.php/Bluetooth_headset

### GPIO
They have zero to limited documentation for using GPIO at the moment. They said they will have an update in 2 weeks (from 12.8.16), so for the time being I plan on tinkering with sysfs and other wrappers, to see what is compatible.<br>

## Use case
~ A $30 version of this:<br> https://www.amazon.com/SanDisk-Wireless-Smartphones-Tablets-SDWS1-032G-A57/dp/B00DR8LAE2?th=1<br>
~ <a href='https://github.com/BiTinerary/PocketServerPi/blob/master/miscScripts/blinkPerOrder.py'>blinkPerOrder.py</a> uses eBay API to get current orders that haven't been shipped, then blinks onboard LED that many times.
~ Consistant, Portable access to a Linux box or python terminal.<br>
~ Linux box that can be used as a disposable scratchpad.<br>
~ Painless and local (much safer) Samba Share for file sharing between work **and** home without ever touching a button<br>
~ Minidlna server for Consoles, Medial Players, etc...<br>
~ `if static ip present; do wakeonlan` ie: wireless, buttonless, IOT trigger.<br>
~ Captive portals and automated node/client pentesting.<br>

## TODO
* Wifi Mode automation and swap from Client to AP has proved to work reliably. Python scripts (switchAPMode/blinkPerOrder) should be moved, to /etc/network/if-down.d and if-up.d respectively.
  * Python scripts should **not** have .py extension but `#!/bin/python` on line 0, also the crontab/Launch on startup can be destroyed.
* Create a basic, generalized image (personal passwords/credz removed) so that USB to UART adapter is not needed for setup and can be accessed directly via SSH, Butterfly, Putty etc...
* Boot as HID device, extending the "swiss army knife" capabilities to Rubber Ducky territory.

## <u>Credit</u>
<u>Tutorials confirmed to work, as instructed (limited to no yakshaving), on Nano Pi Neo Air running Friendly Arm Kernel 3.4.39</u>
- Mr. Anderson's answer that didn't get enough credit, <a href='http://askubuntu.com/questions/59458/error-message-when-i-run-sudo-unable-to-resolve-host-none'>here</a>.
- This bluetooth tutorial: https://wiki.archlinux.org/index.php/Bluetooth_headset
- Setup Samba: https://help.ubuntu.com/community/How%20to%20Create%20a%20Network%20Share%20Via%20Samba%20Via%20CLI%20(Command-line%20interface/Linux%20Terminal)%20-%20Uncomplicated,%20Simple%20and%20Brief%20Way!
- Setup minidlna: https://help.ubuntu.com/community/MiniDLNA
- Setup proftpd: https://www.liquidweb.com/kb/how-to-install-and-configure-proftpd-on-ubuntu-14-04-lts/
