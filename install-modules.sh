#!/bin/sh
set -e
. paths
cd $BASEPATH/kernel
INSTALL_MOD_PATH=$BASEPATH/$GENNAME make modules_install
