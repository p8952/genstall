#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh || true
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

cd /
umount -l /mnt/gentoo/dev{/shm,/pts,} || true
umount -l /mnt/gentoo{/boot,/proc,} || true
rm -rf /mnt/gentoo || true
