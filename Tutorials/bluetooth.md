# Bluetooth

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
