#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

cd /
umount -l /mnt/gentoo/dev{/shm,/pts,} || true
umount -l /mnt/gentoo{/boot,/proc,} || true
