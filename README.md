# PocketServerPi
A backup copy of my NanoPi Neo Air setup that I felt was worth documenting. More or less, my setup produces a portable proftpd, SSH, bluetooth media, minidlna, Access Point **and** samba server, etc.. rolled into one, for $25.

<img src="https://s16.postimg.org/yhsbsdlj9/IMG_1838.jpg">

**Table of Contents**<br>
- [Build Materials](#build-materials)

## Build Materials
* <a href='http://www.friendlyarm.com/index.php?route=product/product&product_id=151'>NanoPi Neo Air</a>: $17.99 + $8 Shipping<br>
My total cost after tax, shipping, hardware and a clear acrylic case [recommended for only $3.00] was $28.98

* <a href='https://www.amazon.com/gp/product/B01E0918J8/ref=oh_aui_detailpage_o02_s01?ie=UTF8&psc=1'>32gb UHS-I Lexar Micro SD Card</a>: <strike>$9.49</strike><br>
If you're buying a NanoPi Neo Air, then this probably isn't your first rodeo. Use an SD card you have lying around.

* <a href='http://www.taydaelectronics.com/bte13-007-cp2102-serial-converter-usb-2-0-to-ttl-uart-ftdi.html'>USB to UART Adapter</a>: $1.99<br>
I ordered 4-5 items in addition to 2 of these from <a href='http://www.taydaelectronics.com'>Tayda</a> and S&H was only $1.26.

* <a href='https://www.sparkfun.com/pages/RF_Conn_Guide'>U.FL (aka IPX) Antenna</a>: Cheap<br>
Again, something I took off an OrangePi that didn't need the WiFi Antenna it came with anymore. It's worth mentioning that the Neo Air doesn't include any kind of external **or** internal antenna. You **will** need one of these if you want WiFi.

# Setup
At the end of the day I prefer Armbian kernel and default setup. However, I reluctantly chose FriendlyArm's kernel since only their binaries and drivers support the 'Access Point' feature that plays a significant role in this project. I did try copy/pasting FriendlyArms binaries and other related files to the corresponding locations, outlined in FriendlyArm's `turn-wifi-into-apmod` binary, on an Armbian kernel but to no avail. Furthermore, Armbian forums mentioned multiple times that their kernel/drivers don't support an Access Point and "Nothing will ever improve."

## Proof of Concept
<b>SSH over HTTP/S using <a href='https://github.com/paradoxxxzero'>Paradoxxxzero</a>'s <a href='https://github.com/paradoxxxzero/butterfly'>Butterfly</a> and a Samba server connection using <a href='https://play.google.com/store/apps/details?id=com.metago.astro&hl=en'>Astro File Manager</a>, running on Android Lollipop v5.0.1<br>
<p align="center"><img src='https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sshoverhttpviabutterfly.gif'>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<img src="https://github.com/BiTinerary/PocketServerPi/blob/master/GitPics/sambaserverresize.gif"></p>

## Use case:
~ A $30 version of this: https://www.amazon.com/SanDisk-Wireless-Smartphones-Tablets-SDWS1-032G-A57/dp/B00DR8LAE2?th=1<br>
~ Consistant, Portable access to a Linux box or python terminal.<br>
~ Linux box that can be used as a `riskless` scratchpad.<br>
~ Painless Samba Share for file sharing work **and** home<br>
~ Minidlna server for Consoles, Medial Players, etc...<br>
~ `if static ip present; do wakeonlan`<br>
~ Captive portals<br>

## Todo
* Create a basic, generalized image (personal passwords/credz removed) so that USB to UART adapter is not needed for setup and can be accessed directly via SSH, Butterfly, Putty etc...
