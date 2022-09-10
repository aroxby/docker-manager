#!/bin/sh -e

set -o pipefail

MACHINE_NAME=docker-manager-1

# TODO: Would be nice to grab this from showvminfo too
HOST_ONLY_DEV_NAME=$(VBoxManage list hostonlyifs | grep Name: | head -n1 | sed 's/Name: \s*//')
VM_MAC=$(VBoxManage showvminfo $MACHINE_NAME --machinereadable | grep -i macaddress2 | cut -d\" -f2)

get_ip() {
    VBoxManage dhcpserver findlease --interface="$HOST_ONLY_DEV_NAME" --mac-address=$VM_MAC 2>/dev/null | \
        grep "IP Address:" | \
        sed 's/IP Address: *//'
}

echo Waiting for DHCP...

while ! get_ip; do
    sleep 1
done
