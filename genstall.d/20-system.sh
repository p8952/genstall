#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

mkdir -p /mnt/gentoo
cd /mnt/gentoo
wget $_STAGE3_URI
tar xjpf stage3-*.tar.bz2
rm stage3-*.tar.bz2

cat > /mnt/gentoo/etc/portage/make.conf << EOF
CFLAGS="-O2 -pipe"
CXXFLAGS="${CFLAGS}"
CHOST="x86_64-pc-linux-gnu"

MAKEOPTS="-j3 -l1.75"
EMERGE_DEFAULT_OPTS="--jobs=3 --load-average=1.75"

USE="bindist mmx sse sse2"
PORTDIR="/usr/portage"

GENTOO_MIRRORS="$DIST_MIRROR"
SYNC="$SYNC_MIRROR"
EOF

cp -L /etc/resolv.conf /mnt/gentoo/etc/

mount --rbind /dev /mnt/gentoo/dev
mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys

$_CHROOT emerge-webrsync
$_CHROOT eselect news read --quiet all
