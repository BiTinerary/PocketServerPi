For Windows:

* Download and install <a href='http://www.putty.org/'>Putty</a>
* Connect your <a href='http://www.taydaelectronics.com/bte13-007-cp2102-serial-converter-usb-2-0-to-ttl-uart-ftdi.html'>USB to UART</a> adapter from your computer to your Nano Pi Neo Air (or any COM device)
 * Make sure you connect TX>RX and RX>TX (Sending/Receiving), otherwise both your devices are talking at the same time and neither one is being heard.

* On Windows OS, pull up the Device Manager
  * Run Windows (<kbd>WinKey</kbd>+<kbd>R</kbd>) and type in `devmgmt.msc`<br>

<img src='https://s18.postimg.org/h7uzve5l5/devmgmt.png'><br>
* Find COM Port Number<br>

Under, Ports (COM & LPT), there should be only one item which has the COM Port number listed in parentheses at the end.<Br>
In my case this is COM5<br>

<img src='https://s16.postimg.org/709iowwet/dev_Window_COM.png'><br>
(COM & LPT drop down menu doesn't appear unless you actually have a COM device connected)<br>

* Establish Serial Connection:<br>

In putty, choose the "Serial" radio button. Type in `115200` under speed (aka BAUD rate) and type in your COM Port number into "Serial Line" and then hit the "Open" button<br>
<img src='https://s17.postimg.org/9i3a6nf9r/connect_Serial.png'>

At this point you may just see a black window, that's likely because the device has already booted and isn't printing to the serial connection. If this is the case, try simply hitting <kbd>Enter</kbd>, or typing something, and it should change the terminal. <br>

Simply plugging in the device again, re-opening the serial connection before it boots up all the way, should result in being able to see the boot sequence whiz by, ending with a login prompt.<br>