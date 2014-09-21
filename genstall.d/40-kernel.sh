#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

_EMERGE sys-kernel/gentoo-sources sys-kernel/genkernel sys-boot/grub

$_CHROOT /bin/bash << EOF
cd /usr/src/linux
genkernel all --makeopts=-j3 --no-compress-initrd --no-zfs
mount -o remount,rw /boot
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub/grub.cfg
EOF
