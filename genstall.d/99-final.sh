#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh

cd /
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -l /mnt/gentoo{/boot,/proc,}
shutdown -h now
