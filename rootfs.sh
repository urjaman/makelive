#!/bin/sh
. ./paths
cd $BASEPATH
rm -rf $GENNAME
mkdir $GENNAME
mkdir $GENNAME/dev
mkdir $GENNAME/proc
mkdir $GENNAME/sys
mkdir $GENNAME/boot
mkdir $GENNAME/home
mkdir $GENNAME/root
cd $GENNAME/dev
mknod -m 666 null c 1 3
mknod -m 666 zero c 1 5
mknod -m 444 random c 1 8
mknod -m 444 urandom c 1 9
mknod -m 666 tty c 5 0
cd $BASEPATH
set -e
# base dev-system-ish...
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vak @system dhcpcd links make sys-devel/gcc sys-devel/binutils dev-vcs/git dev-vcs/subversion hwids
# things for other people, well, mostly
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk man man-pages vim
# things for me ;p
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk fbset usbutils
# the flashrom(s) :P
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk flashrom-git flashrom-urjaman
# The AVR stuff (for serprog work), manually forced ordering to link libusb with avrdude etc
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk avrdude
# These need manually forced ordering (also, they need to be installed in the host, but they are..) (=ROOT support for these, not really existant :P)
# And they were made with crossdev --target avr --init-only or something like that, look in the crossdev help.
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk cross-avr/binutils
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk cross-avr/gcc
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk cross-avr/avr-libc
# This is a bug in the crossdev-based AVR tools :/
ln -s ../../i486-pc-linux-gnu/avr/lib/ldscripts $GENNAME/usr/avr/lib/ldscripts
# null out the password so it's possible to login locally without mage-like information :P
# Please set a password if you're going to run it for more than 5min :P (or enable ssh or something)
passwd -R $BASEPATH/$GENNAME -d root
echo hostname="$GENNAME" > $GENNAME/etc/conf.d/hostname
chroot $GENNAME rc-update del keymaps boot
chroot $GENNAME rc-update del fsck boot
chroot $GENNAME rc-update del swap boot
rm $GENNAME/etc/fstab
echo >> $GENNAME/etc/fstab
echo "tmpfs / tmpfs defaults 0 0" >> $GENNAME/etc/fstab
echo >> $GENNAME/etc/fstab
