#!/bin/sh
set -e
./rootfs.sh
./kernel.sh
./install-modules.sh
./initramfs.sh
./cleanup.sh
./iso.sh
