# PocketServerPi
A backup copy of my NanoPi Neo Air setup, running Armbian, that I felt was worth documenting. More or less, my setup produces a portable proftpd, SSH, bluetooth media, minidlna, Access Point **and** samba server, etc.. rolled into one, for ~$30.

<img src='https://s18.postimg.org/4r4brjkd5/nano_Pi_OTG2.jpg'>
<img src="https://s16.postimg.org/yhsbsdlj9/IMG_1838.jpg">

## Table of Contents
- [Concept, Examples and Specs](#proof-of-concept-examples-and-specs)
- [Build Materials](#build-materials)
- [Installation](#installation)
- [Tutorials](#tutorials)
  - [Wifi](#wifi)
  - [Basic Tools](#initial-setup-and-tools)
  - [i2C Screen](#i2c-screen-ssd1306)
  - [Auto Swap WiFi AP/Client](#auto-swap-wifi-ap-and-client)
  - [Bluetooth](#bluetooth)
  - [GPIO](#gpio)

## Proof of Concept, Examples and Specs
SSH over HTTP/S using <a href='https://github.com/paradoxxxzero'>Paradoxxxzero</a>'s <a href='https://github.com/paradoxxxzero/butterfly'>Butterfly</a> and a Samba server connection using <a href='https://play.google.com/store/apps/details?id=com.metago.astro&hl=en'>Astro File Manager</a>, running on Android Lollipop v5.0.1<br>
<p align="center"><img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sshoverhttpviabutterfly.gif'>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sambaserverresize.gif"></p>
* <b>Runtime</b>: 4 hours 19 minutes on 2200mAh battery
* <b>FPS</b>: 15-20FPS on SSD1306

## Build Materials
* <a href='http://www.friendlyarm.com/index.php?route=product/product&product_id=151'>NanoPi Neo Air</a>: $17.99 + $8 Shipping<br>
My total cost after tax, shipping, hardware and a clear acrylic case [recommended for only $3.00] was $28.98
* <a href='https://www.amazon.com/gp/product/B01E0918J8/ref=oh_aui_detailpage_o02_s01?ie=UTF8&psc=1'>32gb UHS-I Lexar Micro SD Card</a>: <strike>$9.49</strike><br>
If you're buying a NanoPi Neo Air, then this probably isn't your first rodeo. Use a Micro SD you have lying around.
* <a href='http://www.taydaelectronics.com/bte13-007-cp2102-serial-converter-usb-2-0-to-ttl-uart-ftdi.html'>USB to UART Adapter</a>: $1.99<br>
I ordered 4-5 items in addition to 2 of these from <a href='http://www.taydaelectronics.com'>Tayda</a> and S&H was only $1.26.
* <strike><a href='https://www.sparkfun.com/pages/RF_Conn_Guide'>U.FL (aka IPX) Antenna</a>: Cheap<br></strike> NanoPi NeoAir's now ship with the necessary antenna included from FriendlyArm.

## Installation

You know the drill. Get your Micro SD Card out. Here's Armbian's link to <a href='https://www.armbian.com/nanopi-neo-air/'>download</a> their kernel. Write to a MicroSD card using <a href='https://sourceforge.net/projects/win32diskimager/files/Archive/'>Win32 Disk Imager</a>. Put MicroSD into device, wait for LEDs to blink. From here you will need to use your USB to UART Adapter to make a serial connection between your computer and the NeoAir. If you are unfamiliar with that process, or having difficulty, check out this <a href='https://gist.github.com/BiTinerary/5d759c5715c2432e9830842171f97c4c'>Gist</a>. You won't always need to use the UART adapter, just enough to get you going.

Armbian's default credentials are as follows<br>
user:`root` password:`1234`<br>
You will immediately be prompted to change password and create a sudoer user. Congratulations. You're in. Now for fun stuff.

## Tutorials

### Wifi
Armbian makes connecting to the internet easy by including `nmtui` (Network Manager Text User Interface Tool). Connecting to an SSID should be self explanitory so I'm not going to go into crazy specifics. However, here's the idea.
Simply type command `nmtui`, you'll see a text based GUI >> "Activate a connection" >> Select "Your SSID Name" >> "Activate" >> Prompted for SSID Password >> You're good to google. If you would like to change more settings, activate the AccessPoint then go back and select "Edit a Connection"

### Initial Setup and Tools
Here's a <a href='https://gist.github.com/BiTinerary/82fc8a5c9fd15935c6c96d067f4ee1bd'>bash script</a> of the things I start off with to get the essentials and tools that are not included in Armbian for minimalist reasons. ie: pip, python-dev tools, updates, samba server, etc...<br>
It's not been tested (as a bash script), just a reference of working step-by-step commands.

### i2c Screen SSD1306
<img src='https://s12.postimg.org/lawg9srv1/IMG_9943.jpg'><br>
<br>
Here's a repo of a python module that I've tested and used for screens. Give this guy some credit!<a href='https://github.com/rm-hull/luma.oled'>https://github.com/rm-hull/luma.oled</a><br>
In a perfect world, you'd run this.<br>
`git clone https://github.com/rm-hull/luma.oled`<br>
`cd luma.oled/ && pip install .`<br>
`git clone https://github.com/rm-hull/luma.examples`<br>
`python ./luma.examples/examples/sys_info.py --display ssd1306 --interface i2c --i2c-port 0`<br>
<br>
However, expect missing dependencies, errors codes when trying to install the repo because RM-Hull's repo is aimed at Raspi devices, which includes different libraries by default than Armbian<br>
Let me save you some yak shaving by showing you <a href='https://gist.github.com/BiTinerary/60a20e7bc5a76320d7e6e3230b79c392'>this gist</a> which goes over, in brief detail, the commands I run everytime, to get requirements and the SSD1306 up and running.

Full documentation, installation and example code are available here: <a href='https://luma-oled.readthedocs.io'>https://luma-oled.readthedocs.io</a> Note that for the NanoPi NeoAir, the example code works, you just have to <b>change ports</b> `port=1` to `port=0`<br>
Through the `bubbles.py` test script and eye balling it, the SSD1306 gets about <b>15-20FPS</b>.<br>
<br>
The same guy also provides test scripts for animations, games, system info and more. Those scripts can be downloaded from a repository over <a href='https://github.com/rm-hull/luma.examples'>here</a>. You run them like so...<br>
`sudo python sys_info.py --display ssd1306 --interface i2c --i2c-port 0`<br>

### Auto Swap WiFi AP and Client
This is a ported tutorial from when I was using FriendlyArm's kernel. So at the moment I haven't had the opportunity to flush out APMode swapping, that proved to work seemlessly in the previous version.
For now FergusL over on the Armbian forums was kind enough to make some bash scripts to do that. I haven't got them working as of yet but I'm pretty sure it's user error on my part. So results will vary :P <a href='https://forum.armbian.com/index.php/topic/3515-nanopi-neo-air-access-point/?p=26591'>Here's</a> a link to that. I've also duplicated them to the following gists, in case the link/post goes bad and for personal quick reference.<br><a href='https://gist.github.com/BiTinerary/693b8949ed56d6c534d138b9ba2b837e#file-stamode-sh'>stamode.sh</a> & <a href='https://gist.github.com/BiTinerary/693b8949ed56d6c534d138b9ba2b837e#file-apmode-sh'>apmode.sh</a><br>
</strike>

### Bluetooth
- <a href='https://gist.github.com/BiTinerary/f7129a98823d5a130607fc9a26d2d4c0'>This Gist</a><br>
or
- This tutorial that is confirmed to work: https://wiki.archlinux.org/index.php/Bluetooth_headset

### GPIO
To be determined. RPi.GPIO works though, with alterations.

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