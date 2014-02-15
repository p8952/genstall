#!/usr/bin/env bash
source /tmp/00-settings.sh

echo $TIMEZONE > /mnt/gentoo/etc/timezone
$_CHROOT emerge --config sys-libs/timezone-data

cat > /mnt/gentoo/etc/locale.gen << EOF
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF
$_CHROOT locale-gen

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

$_CHROOT /bin/bash << EOF 
cd /etc/init.d
ln -s net.lo net.$ETH0
rc-update add net.$ETH0 default
EOF

$_CHROOT passwd root << EOF
$PASSWORD
$PASSWORD
EOF
