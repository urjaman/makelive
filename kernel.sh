#!/bin/sh
set -e
. ./paths
cd $BASENAME
rm -f tinygentoo-boot/vmlinuz
if [ ! -d kernel ]; then
	cp -a /usr/src/linux-4.4.6-gentoo kernel
fi
cd kernel
make mrproper
cp ../kernel-cfg .config || true
make menuconfig
#make oldconfig
make bzImage modules
cp arch/boot/x86/bzImage ../boot/vmlinuz
