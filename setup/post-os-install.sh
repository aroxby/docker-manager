#!/bin/sh -e
mkdir /target
mount /dev/sda3 /target

sed -i \
    -e 's/^\(\s*set timeout\)=[0-9]\+/\1=0/' \
    /target/boot/grub/grub.cfg

umount /dev/sda3

apk add efibootmgr
efibootmgr --bootnext 0001
