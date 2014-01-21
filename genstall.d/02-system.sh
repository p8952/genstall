#!/usr/bin/env bash
source /tmp/00-settings.sh

cd /mnt/gentoo
wget $STAGE3_URI
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

mount -t proc proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev

$CHROOT emerge-webrsync
$CHROOT emerge --sync --quiet
$CHROOT eselect news read --quiet all

echo $TIMEZONE > /mnt/gentoo/etc/timezone
$CHROOT emerge --config sys-libs/timezone-data

cat > /mnt/gentoo/etc/locale.gen << EOF
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF
$CHROOT locale-gen

cat > /mnt/gentoo/etc/fstab << EOF
# <fs>        <mountpoint>        <type>        <opts>            <dump/pass>
/dev/sda2     /boot               $BOOT_FS      noauto,noatime    0 2
/dev/sda3     none                swap          sw                0 0
/dev/sda4     /                   $ROOT_FS      defaults,noatime  0 1
EOF

cat > /mnt/gentoo/etc/conf.d/hostname << EOF
hostname="$HOSTNAME"
EOF

ETH0=$(ifconfig | head -1 | awk '{print $1}' | sed 's/://')

cat > /mnt/gentoo/etc/conf.d/net << EOF
config_$ETH0="dhcp"
EOF

$CHROOT /bin/bash << EOF 
cd /etc/init.d
ln -s net.lo net.$ETH0
rc-update add net.$ETH0 default
EOF

$CHROOT passwd root << EOF
$PASSWORD
$PASSWORD
EOF
