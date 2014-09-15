#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh

$_CHROOT emerge $SOFTWARE

for D in $DAEMONS; do 
	$_CHROOT rc-update add $D default
done
