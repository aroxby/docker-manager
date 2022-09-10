FROM alpine:3

# qemu-ui-gtk is still needed for qemu-ui-sdl to work for some reason
RUN apk add dosfstools mtools p7zip qemu qemu-img qemu-system-x86_64 qemu-ui-gtk qemu-ui-sdl

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

CMD qemu-img create -f qcow2 sda.img 100G && qemu-system-x86_64 \
    -display sdl \
    -smp 4 \
    -m 8192 \
    -drive file=/usr/share/qemu/edk2-x86_64-code.fd,if=pflash,format=raw \
    -drive file=sda.img,format=qcow2 \
    -drive file=/alpine-usb.vdi,format=vdi,readonly=on,if=none,id=alpine-usb \
    -usb \
    -device usb-storage,drive=alpine-usb \
    -nic user,hostfwd=tcp::2222-:22
