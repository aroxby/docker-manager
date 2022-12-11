#!/bin/sh -e

SCRIPT_DIR=$( cd -- "$( dirname -- "$0" )" 1>/dev/null 2>&1 && pwd )
MACHINE_NAME=docker-manager-1

box_up() {
    VBoxManage list runningvms | grep "^\"$MACHINE_NAME\""
}

if ! box_up; then
    ${SCRIPT_DIR}/start.sh
fi

echo Waiting for VM to start...

while ! box_up; do
    sleep 5
done
