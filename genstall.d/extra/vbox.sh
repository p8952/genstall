#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

_EMERGE app-emulation/virtualbox-guest-additions
$_CHROOT rc-update add virtualbox-guest-additions default

$_CHROOT /bin/bash << EOF
rm -f /usr/portage/distfiles/*
dd if=/dev/zero of=/zero bs=1024x1024; rm -f /zero
dd if=/dev/zero of=/boot/zero bs=1024x1024; rm -f /boot/zero
swapoff -a
dd if=/dev/zero of=/dev/sda3 bs=1024x1024
mkswap /dev/sda3
cd /usr/src/linux
make clean
EOF
