#!/bin/bash
set -x #echo on

#setup and configuration
#sudo -i
#rm -rf ~/.dvdcss
#apt-get install libdvdread4
#/usr/share/doc/libdvdread4/install-css.sh
#apt-get install dvdbackup
#apt-get install gddrescue

rm -rf dvd_structure
#rm -rf ~/.dvdcss

#regionset

#umount /dev/dvd

DVD_NAME=$(blkid -o value -s LABEL /dev/cdrom)

echo "starting iso of $DVD_NAME"

rm "$DVD_NAME.iso"
rm "$DVD_NAME.log"

ddrescue -v -n -b 2048 /dev/cdrom "$DVD_NAME.iso" "$DVD_NAME.log"

eject

dvdbackup -v -M  -i "$DVD_NAME.iso" -o dvd_structure

mkisofs -dvd-video -o "clean/$DVD_NAME.iso" "dvd_structure/$DVD_NAME"

