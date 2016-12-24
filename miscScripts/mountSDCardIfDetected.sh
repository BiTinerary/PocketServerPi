if fdisk -l | grep mmcblk1p1 ; then sudo mount /dev/mmcblk1p1 /home/stuxnet/samba/SDCard/; else echo "Drive Present..." fi
