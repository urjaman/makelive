#!/bin/sh
set -e
. ./paths
cd $BASEPATH
# FYI, genkernel will mknod a few devices, and officially in an nspawn container you cant do that (generally for more than like zero and null),
# but you actually can go to the devices cgroup sysfs thing for the container in the host and enable mknod-ing any device with echo 'a *:* m' > devices.allow
rm -f boot/initramfs
genkernel --no-btrfs --no-zfs  --disklabel --compress-initramfs-type=gzip --install --bootdir=$BASEPATH/boot/ --module-prefix=$BASEPATH/$GENNAME/ --kerneldir=$BASEPATH/kernel initramfs
cd boot
mv initramfs* initramfs
