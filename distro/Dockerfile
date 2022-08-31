FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install p7zip-full qemu-kvm xorriso

ARG alpine_version=3.16.2

ADD https://dl-4.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-virt-${alpine_version}-x86_64.iso /src/
ADD https://dl-4.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-minirootfs-${alpine_version}-x86_64.tar.gz /src/
# COPY alpine-virt-${alpine_version}-x86_64.iso /src/
# COPY alpine-minirootfs-${alpine_version}-x86_64.tar.gz /src/

COPY apkvol-setup.sh /src/
RUN /src/apkvol-setup.sh

CMD qemu-system-x86_64 -bios /usr/share/ovmf/OVMF.fd -m 4096 -cdrom /alpine.iso -net nic -net user,hostfwd=tcp::2222-:22
