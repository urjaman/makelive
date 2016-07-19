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
# things for other people, then for me :P
EXTRATHINGS="man man-pages vim fbset usbutils sshfs nano strace sys-devel/gdb weechat app-misc/screen gawk"
# base dev-system-ish...
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vak @system dhcpcd links make sys-devel/gcc sys-devel/binutils dev-vcs/git dev-vcs/subversion hwids $EXTRATHINGS
#pre-load the libusbs before avrdude
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vk libusb-compat libusb
# the flashrom(s) :P (and avrdude since trying to reduce to number of emerges)
emerge --config-root=$BASEPATH/cfg/ --root=$BASEPATH/$GENNAME/ -vak flashrom-git flashrom-urjaman avrdude
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
chroot $GENNAME rc-update del hwclock boot
echo > $GENNAME/etc/fstab
echo "tmpfs / tmpfs defaults 0 0" >> $GENNAME/etc/fstab
echo >> $GENNAME/etc/fstab
echo "UTC" > $GENNAME/etc/timezone
cp -f $GENNAME/usr/share/zoneinfo/UTC $GENNAME/etc/localtime
echo "en_US.UTF-8 UTF-8" > $GENNAME/etc/locale.gen
echo 'LANG="en_US.utf8"' > $GENNAME/etc/env.d/02locale
touch $GENNAME/usr/share/locale/locale.alias
chroot $GENNAME locale-gen
ROOT=$BASEPATH/$GENNAME env-update

