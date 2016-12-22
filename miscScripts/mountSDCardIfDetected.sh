if fdisk -l | grep mmcblk1p1 ; then echo "Drive present..."; else sudo mount /dev/mmcblk1p1 /home/stuxnet/samba/SDCard/; fi
