#!/usr/bin/env bash
source /tmp/00-settings.sh

$CHROOT emerge sys-kernel/gentoo-sources sys-kernel/genkernel sys-boot/grub

$CHROOT /bin/bash << EOF 
cd /usr/src/linux 
genkernel all
grub2-install /dev/sda
grub2-mkconfig -o /boot/grub/grub.cfg
EOF
