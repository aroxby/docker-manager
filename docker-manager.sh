#!/bin/sh -e

VM_IP=255.255.255.255  # Chosen because ssh will fail fast with this address
SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
BOOTSTRAP_USER=alpine
DOCKER_USER=docker-manager

create_vm() {
    orchestration/create.sh
    orchestration/wait-for-start.sh
}

get_vm_ip() {
    orchestration/wait-for-start.sh
    # TODO: This feels very brittle
    VM_IP=$(orchestration/wait-for-ssh.sh 2>&1 | tee /dev/stderr | head -n-1 | tail -n1)
    if [ -z "$VM_IP" ]; then
        echo VM did not start ssh >&2
        return 10
    fi
}

provision_vm() {
    get_vm_ip
    scp $SSH_OPTS setup/os-install.sh $BOOTSTRAP_USER@$VM_IP:/tmp
    scp $SSH_OPTS setup/post-os-install.sh $BOOTSTRAP_USER@$VM_IP:/tmp

    # TODO: There's probably a TERM variable I can set to enable color during install
    # Don't ask me why the first space needs escaped.  I really don't know
    ssh $SSH_OPTS $BOOTSTRAP_USER@$VM_IP sh -c "sudo\ /tmp/os-install.sh && sudo /tmp/post-os-install.sh && sudo reboot"
}

install_docker() {
    local SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

    get_vm_ip
    scp $SSH_OPTS setup/install-docker.sh $BOOTSTRAP_USER@$VM_IP:/tmp
    # Don't ask me why the first space needs escaped.  I really don't know
    ssh $SSH_OPTS $BOOTSTRAP_USER@$VM_IP sh -c "sudo\ /tmp/install-docker.sh"
}

docker_env() {
    get_vm_ip
    (
        echo Make sure you can ssh into the docker host first.  Docker wants the host key saved.
        echo
        echo ssh $DOCKER_USER@$VM_IP echo success
        echo
        echo Copy and paste the following statement or run \$\($0 docker_env\)
    ) 1>&2
    echo export DOCKER_HOST="ssh://$DOCKER_USER@$VM_IP"
}

create_vm && provision_vm && install_docker && docker_env
