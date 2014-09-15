#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh

sgdisk -n 1:0:+32M -t 1:ef02 -c 1:"bios-boot"  \
-n 2:0:$BOOT_SIZE -t 2:8300 -c 2:"linux-boot" \
-n 3:0:$SWAP_SIZE -t 3:8200 -c 3:"swap"       \
-n 4:0:$ROOT_SIZE -t 4:8300 -c 4:"linux-root" \
-p /dev/sda

mkfs.$BOOT_FS /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mkfs.$ROOT_FS /dev/sda4

mount /dev/sda4 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/sda2 /mnt/gentoo/boot
