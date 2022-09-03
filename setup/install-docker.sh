#!/bin/sh -e
SOURCE_USER=alpine
DOCKER_USER=docker-manager

cat > /etc/apk/repositories << EOF
http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
http://dl-cdn.alpinelinux.org/alpine/latest-stable/community
EOF

apk add docker
service docker start
rc-update add docker

adduser -D $DOCKER_USER
# This enabled console and SSH login.
# I thought about disabling console login it's a lot of work for very little gain
passwd -u $DOCKER_USER
addgroup $DOCKER_USER docker

mkdir -p /home/$DOCKER_USER/.ssh
cp /home/$SOURCE_USER/.ssh/authorized_keys /home/$DOCKER_USER/.ssh/authorized_keys
chmod 700 /home/$DOCKER_USER/.ssh
chmod 600 /home/$DOCKER_USER/.ssh/authorized_keys
chown -R $DOCKER_USER:$DOCKER_USER /home/$DOCKER_USER
