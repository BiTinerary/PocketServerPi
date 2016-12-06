# PocketServerPi
A backup copy of my NanoPi Neo Air setup that I felt was worth documenting. More or less, my setup produces a portable proftpd, SSH, bluetooth media, minidlna, Access Point **and** samba server, etc.. rolled into one, for $25.

<img src="https://s16.postimg.org/yhsbsdlj9/IMG_1838.jpg">

##**Table of Contents**<br>
- [Build Materials](#build-materials)
- [Installation](#installation)
- [Tutorials](#tutorials)
  - [Wifi](#wifi)
  - [Basic Tools](#basic-cli-tools)
  - [Auto Switch Between AP Mode and Wifi Client](#auto-switch-between-ap-mode-and-client)
    - [Python Script](#python-script)
    - [Cron Jobs](#cron-jobs)
  - [Bluetooth](#bluetooth)
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
At the end of the day I prefer Armbian kernel and default setup. However, I reluctantly chose FriendlyArm's kernel since only their binaries and drivers support the 'Access Point' feature that plays a significant role in this project. I did try copy/pasting FriendlyArms binaries and other related files to the corresponding locations, outlined in FriendlyArm's `turn-wifi-into-apmod` binary, on an Armbian kernel but to no avail. Furthermore, Armbian forums mentioned multiple times that their kernel/drivers don't support an Access Point and "Nothing will ever improve."

## Tutorials

### Wifi

### Basic CLI Tools

### Auto Switch Between AP Mode and Client

### Python Script

### Cron Jobs

### Bluetooth
At the moment FriendlyArm has zero info on their website, forums and wiki. However, I'll get an update from them with some info on 12.9.16. In the meantime, I've discovered that <a href='https://wiki.archlinux.org/index.php/Bluetooth_headset'>THIS</a> tutorial works perfectly for finding, pairing, trusting and auto connecting to bluetooth devices. I've yet to actually get audio over bluetooth however, something TODO. Likely an issue with PulseAudio vs Alsa.<br>
`sudo apt-get install pulseaudio-alsa, pulseaudio-bluetooth, bluez, bluez-libs, bluez-utils, bluez-firmware -y`<br>
`bluetoothctl`<br>
`power on`<br>
`agent on`<br>
`default-agent`<br>
`scan on`<br>

**`[NEW] Device 00:00:00:77:44:AA Aduro SBN40`**<br>
`pair 00:00:00:77:44:AA`<br>

**`[CHG] Device 00:00:00:77:44:AA Paired: yes`**<br>
**`Pairing successful `**<br>
**`[CHG] Device 00:00:00:77:44:AA Connected: no`**<br>
`connect 00:00:00:77:44:AA`<br>

**`Failed to connect: org.bluez.Error.Failed`** : This is when I thought the yakshaving would commence, but I just...<br>
`power no`<br>
`scan on`<br>

**`[CHG] Device 00:00:00:77:44:AA Connected: yes`**<br>
**`Authorize service 0000990R-0000-9000-9000-00000Q0M00GN: (yes/no)`**<br>

`scan off`<br>
`exit`<br>
`bluetoothctl`<br>
`trust 00:00:00:77:44:AA`<br>
`nano /etc/pulse/defaul.pa` : Add following to end of file. (if `default.pa` doesn't exist, then reboot device)<br>
`load-module module-switch-on-connect`<br>

## Proof of Concept and Examples
SSH over HTTP/S using <a href='https://github.com/paradoxxxzero'>Paradoxxxzero</a>'s <a href='https://github.com/paradoxxxzero/butterfly'>Butterfly</a> and a Samba server connection using <a href='https://play.google.com/store/apps/details?id=com.metago.astro&hl=en'>Astro File Manager</a>, running on Android Lollipop v5.0.1<br>
<p align="center"><img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sshoverhttpviabutterfly.gif'>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sambaserverresize.gif"></p>

## Use case:
~ A $30 version of this:<br> https://www.amazon.com/SanDisk-Wireless-Smartphones-Tablets-SDWS1-032G-A57/dp/B00DR8LAE2?th=1<br>
~ Consistant, Portable access to a Linux box or python terminal.<br>
~ Linux box that can be used as a `riskless` scratchpad.<br>
~ Painless Samba Share for file sharing work **and** home<br>
~ Minidlna server for Consoles, Medial Players, etc...<br>
~ `if static ip present; do wakeonlan`<br>
~ Captive portals<br>

## TODO
* Create a basic, generalized image (personal passwords/credz removed) so that USB to UART adapter is not needed for setup and can be accessed directly via SSH, Butterfly, Putty etc...
