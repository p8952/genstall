#!/usr/bin/env bash
set -o errexit
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

cat > /tmp/00-settings.sh << "EOF"

# User Editable Variables

DIST_MIRROR="http://mirror.bytemark.co.uk/gentoo/"
SYNC_MIRROR="rsync://mirror.bytemark.co.uk/gentoo-portage"

BOOT_SIZE="+256MB"
SWAP_SIZE="+1G"
ROOT_SIZE="+10G"

BOOT_FS="ext2"
ROOT_FS="ext4"

TIMEZONE="UTC"
HOSTNAME="gentoo-amd64"
PASSWORD="gentoo"

SOFTWARE="app-admin/syslog-ng sys-process/cronie"
DAEMONS="syslog-ng cronie sshd"

# Internal Variables

_CORES=$(($(nproc) + 1))
_LATEST_STAGE3=$(curl -s $DIST_MIRROR/releases/amd64/autobuilds/latest-stage3-amd64.txt | tail -1)
_STAGE3_URI="$DIST_MIRROR/releases/amd64/autobuilds/$_LATEST_STAGE3"
_CHROOT="chroot /mnt/gentoo"
function _EMERGE() {
	set +e
	$_CHROOT emerge --pretend "$@"
	if [[ $? == 1 ]]; then
		$_CHROOT emerge --autounmask-write "$@"
		$_CHROOT etc-update --automode -5
	fi
	$_CHROOT emerge "$@"
	set -e
}

EOF
