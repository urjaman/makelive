#!/bin/sh
# Install things needed in a gentoo system BEWARE: overwrites /usr/local/portage by default
set -e
cd /usr/local
if [ -d portage ]; then
	if [ -d portage.old ]; then
		echo "Do something about your /usr/local/portage.old"
		exit 1
	fi
	mv portage portage.old
fi
git clone https://github.com/urjaman/my-gentoo-overlay portage
cd -
mkdir -p /etc/portage/repos.conf
echo "[local]" > /etc/portage/repos.conf/local.conf
echo "location = /usr/local/portage" >> /etc/portage/repos.conf/local.conf
echo "masters = gentoo" >> /etc/portage/repos.conf/local.conf
echo "auto-sync = no" >> /etc/portage/repos.conf/local.conf
. ./paths
emerge -va --noreplace sys-boot/grub sys-devel/crossdev sys-kernel/genkernel dev-libs/libisoburn squashfs-tools
crossdev --target avr --init-target
emerge -va --noreplace cross-avr/binutils
USE="-vtv -openmp" emerge -va cross-avr/gcc
#refresh the crossdev setup in the cfg
PORTAGE_CONFIGROOT=$BASEPATH/cfg/ crossdev --target avr --init-target

#adjust the distfiles and package dirs in cfg/etc/portage/make.conf or whatever if you like
mkdir -p /usr/portage-distfiles
mkdir -p /usr/portage-packages-i486
cp cfg/etc/portage/package.use/ssl /etc/portage/package.use/

