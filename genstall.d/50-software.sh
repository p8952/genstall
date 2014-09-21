#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

_EMERGE $SOFTWARE

for D in $DAEMONS; do
	$_CHROOT rc-update add $D default
done
