#!/bin/sh -e
cat > /tmp/os-install-answers.txt << EOF
# Example answer file for setup-alpine script
# If you don't want to use a certain option, then comment it out

# Use US layout with US variant
KEYMAPOPTS="us us"

# Set hostname to docker-manager
HOSTNAMEOPTS="-n docker-manager"

# Contents of /etc/network/interfaces
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet dhcp
"

# Search domain of example.com, Google public nameserver
# DNSOPTS="-d example.com 8.8.8.8"

# Set timezone to UTC
TIMEZONEOPTS="-z UTC"

# set http/ftp proxy
PROXYOPTS=none

# Use CDN mirror
APKREPOSOPTS="-1"

# Install Openssh
SSHDOPTS="-c openssh"

# Do not use NTP with virtual machines
NTPOPTS="-c none"

# Use /dev/sda as a data disk
DISKOPTS="-m sys /dev/sda"

# Do not set root password (same as -e)
empty_root_password=1

# Suppress prompt to erase the disk
export ERASE_DISKS=/dev/sda
EOF

sudo setup-alpine -f /tmp/os-install-answers.txt