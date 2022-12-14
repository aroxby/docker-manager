#!/bin/sh -e

SCRIPT_DIR=$( cd -- "$( dirname -- "$0" )" 1>/dev/null 2>&1 && pwd )

ssh_up() {
    curl -m3 -s http://$1:22
    [ $? -eq 1 ]
}

VM_IP=$(${SCRIPT_DIR}/wait-for-ip.sh | tee /dev/stderr | tail -n1)

echo Waiting for ssh...

while ! ssh_up $VM_IP; do
    sleep 0
done
