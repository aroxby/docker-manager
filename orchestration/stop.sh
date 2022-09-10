#!/bin/sh -e

# FIXME: alpine doesn't respond to the shutdown signal?

MACHINE_NAME=docker-manager-1
SHUTDOWN_WAIT=10

vm_running() {
    VBoxManage list runningvms | grep $MACHINE_NAME > /dev/null
}

VBoxManage controlvm $MACHINE_NAME acpipowerbutton

echo Waiting for shutdown...

WAITED=0
while vm_running && [ $WAITED -lt $SHUTDOWN_WAIT ]; do
    WAITED=$(( $WAITED + 1 ))
    sleep 1
done

if [ $WAITED -ge $SHUTDOWN_WAIT ]; then
    echo Forcing poweroff
    VBoxManage controlvm $MACHINE_NAME poweroff
fi
