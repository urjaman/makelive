#!/bin/sh
# Install things needed in a gentoo system BEWARE: overwrites /usr/local/portage by default
set -e
cd /usr/local
git clone https://github.com/urjaman/my-gentoo-overlay portage
cd -
. ./paths
emerge -va --noreplace sys-boot/grub sys-devel/crossdev sys-kernel/genkernel dev-libs/libisoburn
crossdev --target avr --init-target
emerge -va cross-avr/binutils
emerge -va cross-avr/gcc
#refresh the crossdev setup in the cfg
PORTAGE_CONFIGROOT=$BASEPATH/cfg/ crossdev --target avr --init-target


