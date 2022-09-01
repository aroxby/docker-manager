FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install p7zip-full qemu-kvm xorriso

ARG alpine_major=3.15
ARG alpine_minor=6
ARG alpine_mirror_url=https://dl-cdn.alpinelinux.org/alpine

ADD ${alpine_mirror_url}/v${alpine_major}/releases/x86_64/alpine-virt-${alpine_major}.${alpine_minor}-x86_64.iso \
    /src/alpine-virt.iso
ADD ${alpine_mirror_url}/v${alpine_major}/releases/x86_64/alpine-extended-${alpine_major}.${alpine_minor}-x86_64.iso \
    /src/alpine-extended.iso
ADD ${alpine_mirror_url}/v${alpine_major}/releases/x86_64/alpine-minirootfs-${alpine_major}.${alpine_minor}-x86_64.tar.gz \
    /src/alpine-minirootfs.tar.gz

# COPY alpine-virt-${alpine_major}.${alpine_minor}-x86_64.iso /src/alpine-virt.iso
# COPY alpine-extended-${alpine_major}.${alpine_minor}-x86_64.iso /src/alpine-extended.iso
# COPY alpine-minirootfs-${alpine_major}.${alpine_minor}-x86_64.tar.gz /src/alpine-minirootfs.tar.gz

COPY apkvol-setup.sh /src/
RUN /src/apkvol-setup.sh
RUN rm -rf /src

CMD qemu-system-x86_64 -bios /usr/share/ovmf/OVMF.fd -m 4096 -cdrom /alpine.iso -net nic -net user,hostfwd=tcp::2222-:22
