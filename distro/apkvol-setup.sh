#!/bin/sh -e

mkdir -p /tmp/distro-build/src

(
    mkdir /tmp/distro-build/dst
    cd /tmp/distro-build/dst
    7z x /tmp/distro-build/src/alpine-virt.iso > /dev/null
    rm -rf [BOOT]
)

(
    mkdir /tmp/distro-build/extened
    cd /tmp/distro-build/extened
    7z x /tmp/distro-build/src/alpine-extended.iso > /dev/null
    cp -a apks /tmp/distro-build/dst
)

mkdir /tmp/distro-build/chroot
tar -C /tmp/distro-build/chroot -xf /tmp/distro-build/src/alpine-minirootfs.tar.gz
cp /etc/resolv.conf /tmp/distro-build/chroot/etc

chroot /tmp/distro-build/chroot sh -e << CHROOT
apk update
apk add alpine-conf busybox-initscripts openssh sudo

touch /etc/.default_boot_services

cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet dhcp
EOF

ln -s /etc/init.d/networking /etc/runlevels/default/
ln -s /etc/init.d/sshd /etc/runlevels/default/
ln -s /etc/init.d/acpid /etc/runlevels/default/

adduser -D -s /bin/sh alpine
addgroup alpine wheel

mkdir /home/alpine/.ssh
chmod 700 /home/alpine/.ssh
# TODO: Parameterize public key
cat > /home/alpine/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/TgYMfiySmr2C6eYGxE2R/Icg8L9/yKwESs7h8cgxNo7HuuBnGD/H59ODD6Rvogyo7KiK9VLDwD9a8flu0DePVMS7gY0Tpe0A8oXzIxO9NbC84Siq4Lly03jJW5QM+e0RaOIPd2u7HJ3lVL3liiNof+JgGVuIFZYDO4VVjjLwnncXlFoK8kJlOKk42z2m0H8Qu8BYdj6kRHwXF7WhXTsdgtfxT99YSRH6c8DG2rgwbHmleYstSZ2SC8QQv4BRC7BR0RrNTJLL1SSfBRKTTm9RDRvsot0B2M5otgzM7GgX6iZBTCZi7uVgXWfrBtyX9dHC1kKB7g1lUs/WIz44ZcgoLiPdNN7f7rs5UgBTqLBLK52xWhr8ez4Zm2FEJ3Hsd5ba4aq581NV/oB60X5faCHvsffvB+QUGstj1bm2U6oPfDDeo70HgPgCZ6V8ceDVJEwHxXZvVoyzsOSiZ9j79y9y6curHKVXnldSI5npuiSyZQv/momLowGADdFykRRNMw+iEcW3XDVo3JFT05yG23C34h+sMY3T64spuksH8gIflopzhhiIfijlvzlBbuSkHRp5B2MzYZo18+b2bdBmwB5lspsMkU+qS/F7LkVq/K4z6pk1J5CYeicqnsfpsPayVew0B1FcTlVLeh89Qx7hoy+m60RGnhKDW10Fn5ZM29oX2w== aroxby@users.noreply.github.com
EOF
chmod 600 /home/alpine/.ssh/authorized_keys
chown -R alpine:alpine /home/alpine

passwd -u alpine  # Enable login (no console password, ssh via key only)

sed -i '/%wheel/s/^# //' /etc/sudoers

lbu exclude \
    etc/group- etc/passwd- etc/shadow- \
    etc/apk/keys etc/apk/arch etc/apk/repositories \
    etc/os-release \
    etc/issue \
    etc/alpine-release
lbu include /home/alpine
lbu package docker-manager.apkovl.tar.gz

CHROOT

mv /tmp/distro-build/chroot/docker-manager.apkovl.tar.gz /tmp/distro-build/dst

sed -i \
    -e 's/^set timeout=[0-9]\+/set timeout=0/' \
    /tmp/distro-build/dst/boot/grub/grub.cfg

mkfs.fat -CF 32 /tmp/distro-build/alpine-usb.img $((600 * 1024))
mcopy -s -i /tmp/distro-build/alpine-usb.img /tmp/distro-build/dst/* ::/

qemu-img convert -f raw -O vdi /tmp/distro-build/alpine-usb.img ~/alpine-usb.vdi

rm -rf /tmp/distro-build
