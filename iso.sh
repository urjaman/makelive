#!/bin/sh
set -e
. ./paths
cd $BASEPATH
rm -rf iso
mkdir iso
touch iso/livecd
mksquashfs $GENNAME iso/image.squashfs
mkdir -p iso/boot/grub
cp -aL boot/* iso/boot
cp grub.cfg iso/boot/grub/grub.cfg
grub2-mkrescue -o $GENNAME.iso iso
# Genkernel scripts will not boot off an usb-stick-as-iso if it has any partitions, so the helpful 0xcd partition by grub sadly has to go :(
printf "d\nw\ny\n" | fdisk $GENNAME.iso
