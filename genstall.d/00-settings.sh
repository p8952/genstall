#!/usr/bin/env bash

cat > /tmp/00-settings.sh << "EOF"

# User Editable Variables

export DIST_MIRROR="http://mirror.bytemark.co.uk/gentoo/"
export SYNC_MIRROR="rsync://mirror.bytemark.co.uk/gentoo-portage"

export BOOT_SIZE="+256MB"
export SWAP_SIZE="+1G"
export ROOT_SIZE="+10G"

export BOOT_FS="ext2"
export ROOT_FS="ext4"

export TIMEZONE="UTC"
export HOSTNAME="gentoo-amd64"
export PASSWORD="gentoo"

export SOFTWARE="app-admin/syslog-ng sys-process/cronie"
export DAEMONS="syslog-ng cronie sshd"

# Internal Variables

export _LATEST_STAGE3=$(curl -s $DIST_MIRROR/releases/amd64/autobuilds/latest-stage3-amd64.txt | tail -1)
export _STAGE3_URI="$DIST_MIRROR/releases/amd64/autobuilds/$_LATEST_STAGE3"
export _CHROOT="chroot /mnt/gentoo"

EOF
