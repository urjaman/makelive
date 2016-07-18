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
