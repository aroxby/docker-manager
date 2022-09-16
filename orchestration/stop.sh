#!/bin/sh -e

MACHINE_NAME=docker-manager-1
SHUTDOWN_WAIT=10

vm_running() {
    VBoxManage list runningvms | grep $MACHINE_NAME > /dev/null
}

echo Waiting for shutdown...

WAITED=0
while vm_running && [ $WAITED -lt $SHUTDOWN_WAIT ]; do
    VBoxManage controlvm $MACHINE_NAME acpipowerbutton
    WAITED=$(( $WAITED + 1 ))
    sleep 1
done

if [ $WAITED -ge $SHUTDOWN_WAIT ]; then
    echo Forcing poweroff...
    VBoxManage controlvm $MACHINE_NAME poweroff
fi
