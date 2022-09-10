#!/bin/sh -e

ssh_up() {
    curl -m3 -s http://$1:22
    [ $? -eq 1 ]
}

VM_IP=$(./get-ip.sh)

echo Waiting for ssh...

while ! ssh_up $VM_IP; do
    sleep 0
done
