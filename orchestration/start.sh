#!/bin/sh -e

MACHINE_NAME=docker-manager-1

VBoxManage startvm $MACHINE_NAME --type headless
