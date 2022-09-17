#!/bin/sh -e

VM_ADDR=255.255.255.255

create_vm() {
    orchestration/create.sh
    orchestration/start.sh
}

get_vm_ip() {
    # TODO: This feels very brittle
    # TODO: Show the "Waiting for ..." messages
    local VM_IP=$(orchestration/wait-for-ssh.sh 2>&1 | head -n-1 | tail -n1)
    if [ -z "$VM_IP" ]; then
        echo VM did not start ssh >&2
    else
        VM_ADDR=alpine@$VM_IP
    fi
}

provision_vm() {
    local SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

    get_vm_ip
    scp $SSH_OPTS setup/os-install.sh $VM_ADDR:/tmp
    scp $SSH_OPTS setup/post-os-install.sh $VM_ADDR:/tmp

    # TODO: There's probably a TERM variable I can set to enable color during install
    # Don't ask me why the first space needs escaped.  I really don't know
    ssh $SSH_OPTS $VM_ADDR sh -c "sudo\ /tmp/os-install.sh && sudo /tmp/post-os-install.sh && sudo reboot"
}

create_vm && provision_vm