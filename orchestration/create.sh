#!/bin/sh -e

MACHINE_NAME=docker-manager-1
HOST_TO_GUEST_REDUCTION=4
INSTALL_VDI=../distro/alpine-usb.vdi
TARGET_VDI_NAME=$MACHINE_NAME.vdi
TARGET_VDI_MAX_SIZE_GB=100

HOST_RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
HOST_RAM_MB=$(expr $HOST_RAM_KB / 1024)
HOST_RAM_GB_ROUND=$(expr $HOST_RAM_MB / 1024 + 1)  # Round up to next GB since MemTotal is ~99%
HOST_RAM_MB_ROUND=$(expr $HOST_RAM_GB_ROUND \* 1024)
GUEST_RAM_MB=$(expr $HOST_RAM_MB_ROUND / $HOST_TO_GUEST_REDUCTION)

HOST_CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
GUEST_CPU_COUNT=$(expr $HOST_CPU_COUNT / $HOST_TO_GUEST_REDUCTION)

create_vm() {
    HOST_ONLY_DEV_NAME=$(VBoxManage list hostonlyifs | grep Name: | head -n1 | sed 's/Name: \s*//')

    VBoxManage createvm --name $MACHINE_NAME --ostype Linux26_64 --register
    VBoxManage modifyvm $MACHINE_NAME \
        --memory $GUEST_RAM_MB \
        --cpus $GUEST_CPU_COUNT \
        --nic2 hostonly \
        --hostonlyadapter2 "$HOST_ONLY_DEV_NAME" \
        --rtcuseutc on \
        --firmware efi

    VBoxManage storagectl $MACHINE_NAME --name SATA --add sata --portcount 4
}

attach_storage() {
    VM_DIR=$(
        dirname "$(
            VBoxManage showvminfo --machinereadable $MACHINE_NAME | grep CfgFile | cut -d= -f2 | cut -d\" -f2
        )"
    )

    VBoxManage createmedium disk --filename "$VM_DIR/$TARGET_VDI_NAME" --size $(expr $TARGET_VDI_MAX_SIZE_GB \* 1024)

    VBoxManage storageattach $MACHINE_NAME \
        --storagectl SATA \
        --port 0 \
        --type hdd \
        --medium "$VM_DIR/$TARGET_VDI_NAME"

    VBoxManage storageattach $MACHINE_NAME \
        --storagectl SATA \
        --port 1 \
        --type hdd \
        --medium $INSTALL_VDI \
        --mtype immutable
}

create_vm
attach_storage
