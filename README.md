# PocketServerPi
A custom NanoPi Neo Air setup, running Armbian 5.25, that I felt was worth documenting. Effectively, the setup can produce a portable proftpd, SSH, bluetooth, minidlna, Access Point **and** samba server, etc.. rolled into one, for ~$30.

<img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/androidOTGToNeoAir.jpg'>
<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/portableNeoAir.jpg">

## Table of Contents
- [Concept, Examples and Specs](#proof-of-concept-examples-and-specs)
- [Build Materials](#build-materials)
- [Installation](#installation)
- [Tutorials](#tutorials)
  - [Wifi](#wifi)
  - [Basic Tools](#initial-setup-and-tools)
  - [SSH in Web Browser](#ssh-in-web-browser-with-novnc)
  - [i2C Screen](#i2c-screen-ssd1306)
  - [Auto Swap WiFi AP/Client](#auto-swap-wifi-ap-and-client)
  - [Bluetooth](#bluetooth)
  - [GPIO](#gpio)
- [Use Cases and Ideas](#use-cases-and-ideas)
- [Credit and Sources](#credit)

## Proof of Concept, Examples and Specs
SSH over HTTP/S using [Paradoxxxzero](https://github.com/paradoxxxzero)'s [Butterfly](https://github.com/paradoxxxzero/butterfly) and a Samba server connection using [Astro File Manager](https://play.google.com/store/apps/details?id=com.metago.astro&hl=en), running on Android Lollipop v5.0.1<br>

* <b>Version</b>: ARMBIAN 5.25 stable Debian GNU/Linux 8 (jessie) 3.4.113-sun8i
* <b>Runtime</b>: 4 hours 19 minutes on 2200mAh battery with a base load.
* <b>FPS</b>: 15-20FPS on SSD1306

<p align="center"><img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sshoverhttpviabutterfly.gif'>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sambaserverresize.gif"></p>

## Build Materials
* [NanoPi Neo Air](http://www.friendlyarm.com/index.php?route=product/product&product_id=151): $17.99 + $8 Shipping  
My total cost after tax, shipping, hardware and a clear acrylic case [recommended for only $3.00] was $28.98
* [32gb UHS-I Lexar Micro SD Card](https://www.amazon.com/gp/product/B01E0918J8/ref=oh_aui_detailpage_o02_s01?ie=UTF8&psc=1): <strike>$9.49</strike>  
If you're buying a NanoPi Neo Air, then this probably isn't your first rodeo. Use a Micro SD you have lying around.
* [USB to UART Adapter](http://www.taydaelectronics.com/bte13-007-cp2102-serial-converter-usb-2-0-to-ttl-uart-ftdi.html): $1.99  
I ordered 4-5 items in addition to 2 of these from [Tayda](http://www.taydaelectronics.com) and S&H was only $1.26.
* <strike>[U.FL (aka IPX) Antenna](https://www.sparkfun.com/pages/RF_Conn_Guide): Cheap</strike>  
NanoPi NeoAir's now ship with the necessary antenna included from FriendlyArm.

## Installation

You know the drill. Get your Micro SD Card out. Here's Armbian's link to [download](https://dl.armbian.com/nanopiair/) their kernel. Write to a MicroSD card using [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/files/Archive/). Put card into device, wait for LEDs to blink. From here you will need to use your USB to UART Adapter to make a serial connection between your computer and the NeoAir. If you are unfamiliar with that process, or having difficulty, check out this [Gist](https://gist.github.com/BiTinerary/5d759c5715c2432e9830842171f97c4c). You won't always need to use the UART adapter, just enough to get you going.

Armbian's default credentials are... User: `root` Pswd: `1234`  
You will immediately be prompted to change password and create a sudoer user.  
  
You can write the contents of the Micro SD card to the onboard eMMC storage by issuing `nand-sata-install`.  
I prefer to hold off on that though and install programs, edit configs, etc... and complete the Linux setup on the Micro SD Card. **Then** I will write to the eMMC. That way all the customizations made on the SD Card don't have to be done a second time on the eMMC side.  
  
Also, I suggest backing up the SD card using the Win32 Disk Imager program from before. This way if anything goes wrong, like after installing an update on the eMMC or accidentally editing too many configs on the SD Card when you thought you were booted from eMMC (things I've done) you're completely covered.  
  
**Tip**: `reboot`ing with a simultaneous installation on the Micro SD Card **and** eMMC might change the precedence of which one is booted. It should be the SD Card but there doesn't seem to be any particular rhyme or reason to it.

## Tutorials

### Wifi
Armbian makes connecting to the internet easy by including `nmtui` (Network Manager Text User Interface Tool). Connecting to an SSID should be self explanitory so I'm not going to go into crazy specifics. However, here's the idea.
Simply type command `nmtui`, you'll see a text based GUI >> "Activate a connection" >> Select "Your SSID Name" >> "Activate" >> Prompted for SSID Password >> You're good to google. If you would like to change more settings, activate the AccessPoint then go back and select "Edit a Connection"

### Initial Setup and Tools
Here's a [bash script](https://gist.github.com/BiTinerary/82fc8a5c9fd15935c6c96d067f4ee1bd) of the things I start off with to get the essentials and tools that are not included in Armbian for minimalist reasons. It's not been tested (as a bash script) but is a working reference to install pip, dev tools, updates, samba, etc...  
  
Ditch the USB to UART adapter and use Serial over USB via OTG with a few simple commands. Credits to tutorial below.  
`sudo su`  
`echo "g_serial" >> /etc/modules`  
`nano /etc/systemd/system/serial-getty@ttyGS0.service.d/10-switch-role.conf`  
  
Make sure the following lines are in that config.  
`[Service]`  
`ExecStartPre=-/bin/sh -c "echo 2 > /sys/bus/platform/devices/sunxi_usb_udc/otg_role"`  
`systemctl --no-reload enable serial-getty@ttyGS0.service`  
`echo "ttyGS0" >> /etc/securetty`  
  
  
If config `file or directory doesn't exist`. Create directory and repeat previous `nano` command to create file.  
`mkdir -p /etc/systemd/system/serial-getty@ttyGS0.service.d`  
You might need a Gadget Serial v2.4 driver if running on Windows. I've included a [.inf file](https://github.com/BiTinerary/PocketServerPi/blob/master/gistScripts/linux-cdc-acm.inf), provided by [this](https://bbs.nextthing.co/t/need-gadget-serial-v2-4-driver-for-windows-7/2044) forum. Just download, run Device Manager (`devmgmt.msc`), right click missing COM Driver, manually select downloaded .inf file.

### SSH in Web Browser with noVNC
Run the `noVNCAutoInstallation.sh` bash script included in this repo. Here I am running `htop` and `wavemon` with a `screen` session. Add `@reboot bash /home/stuxnet/samba/noVNC/vnc.sh` to `crontab -e` to run noVNC on startup and ditch PuTTY/serial completely. Credits for the auto install script to [MitchRatquest](https://github.com/MitchRatquest) and to [noVNC](https://github.com/novnc/noVNC) for their utility.
  
<img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/noVNConScreen.png'>

### i2c Screen SSD1306
<img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/ssd1306NeoAir.jpg'>  
  
Here's a repo of a python module that I've used for screens. Give this guy some credit! https://github.com/rm-hull/luma.oled  
  
In a perfect world, you'd run this:  
`git clone https://github.com/rm-hull/luma.oled`  
`cd luma.oled/ && pip install .`  
`git clone https://github.com/rm-hull/luma.examples`  
`python ./luma.examples/examples/sys_info.py --display ssd1306 --interface i2c --i2c-port 0`  
  
However, expect error codes because RM-Hull's repo is aimed at Raspian devices, which includes different libraries by default than Armbian. That being said, let me save you some yak shaving by showing you [this gist](https://gist.github.com/BiTinerary/60a20e7bc5a76320d7e6e3230b79c392) which briefly details the necessary commands to get the SSD1306 up and running.  
  
Full documentation, installation and example code are available here: [https://luma-oled.readthedocs.io](https://luma-oled.readthedocs.io)  
Note that for the NanoPi NeoAir, you should **change** `port=1` to `port=0`, as stated in docs.
[RM-Hull](https://github.com/rm-hull) also provides test scripts for animations, games, system info and more. Those scripts can be downloaded from a repository over [here](https://github.com/rm-hull/luma.examples). Run them like: `sudo python sys_info.py --display ssd1306 --interface i2c --i2c-port 0`  
Note that example scripts, **must be run from within** the `/luma.examples` folder.  

### Auto Swap WiFi AP and Client
This is a ported tutorial from when I was using FriendlyArm's kernel. So at the moment I haven't had the opportunity to flush out APMode swapping, that proved to work seemlessly in the previous version. For now FergusL over on the Armbian forums was kind enough to make some bash scripts to do that.  
  
I haven't got them working as of yet but I'm pretty sure it's user error on my part. Here's a link to his [post](https://forum.armbian.com/index.php/topic/3515-nanopi-neo-air-access-point/?p=26591). I've also duplicated them with permission to the following gists, in case the link goes bad and for personal quick reference. [stamode.sh](https://gist.github.com/BiTinerary/693b8949ed56d6c534d138b9ba2b837e#file-stamode-sh) & [apmode.sh](https://gist.github.com/BiTinerary/693b8949ed56d6c534d138b9ba2b837e#file-apmode-sh)  

### Bluetooth
[This Gist](https://gist.github.com/BiTinerary/f7129a98823d5a130607fc9a26d2d4c0) or the following tutorial that is confirmed to work(ish): https://wiki.archlinux.org/index.php/Bluetooth_headset

### GPIO
I was able to successfully use [this GPIO library](https://pypi.python.org/pypi/pyA10Lime) to initiate and pull up/down pins. Which I then used on a secondary NanoPiNeo Air to get the state of a reed switch. This didn't come without it's debugging though. I'll spare you the details but this [stack solution](http://stackoverflow.com/questions/40896609/python-compilation-error-cannot-import-name-gpio/43559597) is how I came across that GPIO library, while trying (and failing) to use a similar one meant for another board.
  
After finding that I was able to create and test [reedSwitchState.py](https://github.com/BiTinerary/PocketServerPi/blob/master/reedSwitchState.py). It successfully initiates pin 12 (PA6). Which has a reed switch attached to it. Essentially, if GPIO is pulled low, then reed switch is closed. Do nothing. If pulled high, it's open. Send alert. I'll revisit this section soon and add more detailed instructions with the newb in mind. Regarding pin initiation, GPIO addresses, etc... but for now it's a pretty decent start.

For pin numbers and ports: http://wiki.friendlyarm.com/wiki/index.php/NanoPi_NEO_Air

## Use cases and ideas
- A $30 version of this:  
https://www.amazon.com/SanDisk-Wireless-Smartphones-Tablets-SDWS1-032G-A57/dp/B00DR8LAE2?th=1  
- Minimalist Alerts: [blinkPerOrder.py](https://github.com/BiTinerary/PocketServerPi/blob/master/friendlyArmKernel/miscScripts/blinkPerOrder.py) uses eBay API to get current orders that haven't been shipped, then blinks onboard LED that many times.
- Consistant, Portable access to a Linux box or python terminal.  
- Linux box that can be used as a disposable scratchpad, like in a development setting. [Alpine](https://alpinelinux.org/downloads/) or [Docker](https://store.docker.com/editions/community/docker-ce-server-debian)?
- Painless and local (much safer) Samba Share for file sharing between work **and** home without ever touching a button  
- Minidlna server for Consoles, Medial Players, etc...  
- IOT triggering: https://github.com/BiTinerary/PersonalAPI or `if` connected to SSID, wakeonlan, run music on startup.
- Captive portals and automated node/client pentesting.  
- [p2pADB](https://github.com/kosborn/p2p-adb) `if` new device connected via OTG? `then` run exploit. Save to microSD. `else` wait.

## Credit
- [MitchRatquest](https://github.com/MitchRatquest) for contribution to auto install noVNC. [Here](https://gist.github.com/MitchRatquest/21805fc7c1534d99344acb627721630b)
- noVNC, `nuf said. https://github.com/novnc/noVNC
- Mr. Anderson's answer that didn't get enough credit, [here](http://askubuntu.com/questions/59458/error-message-when-i-run-sudo-unable-to-resolve-host-none).
- [Setup Samba](https://help.ubuntu.com/community/How%20to%20Create%20a%20Network%20Share%20Via%20Samba%20Via%20CLI%20%28Command-line%20interface/Linux%20Terminal%29%20-%20Uncomplicated%2C%20Simple%20and%20Brief%20Way%21)
- RM-Hull for his pythonic screen repositories: https://github.com/rm-hull
- This tutorial for enabling/starting g_serial in Armbian: https://oshlab.com/enable-g_serial-usb-otg-console-orange-pi-armbian/
- This bluetooth tutorial: https://wiki.archlinux.org/index.php/Bluetooth_headset
- Setup minidlna: https://help.ubuntu.com/community/MiniDLNA
- Setup proftpd: https://www.liquidweb.com/kb/how-to-install-and-configure-proftpd-on-ubuntu-14-04-lts/

## TODO
- Wifi Mode automation and swap from Client to AP has proved to work reliably in FriendlyArm (Ubuntu) version but not Armbian. This is a **must**. Python scripts (switchAPMode/blinkPerOrder) should be moved, to /etc/network/if-down.d and if-up.d respectively.
  - Python scripts should **not** have .py extension but `#!/bin/python` on line 0, also the crontab/Launch on startup can be destroyed.
  - Hopefully the latest (5.XX.17) update which implements new `armbian-config` command will help with AP Mode swapping and automation. 
- Create a basic, generalized image (personal passwords/credz removed) so that USB to UART adapter is not needed for setup and can be accessed directly via SSH, Butterfly, Putty etc...
- Boot as HID device, extending the "swiss army knife" capabilities to Rubber Ducky territory.
