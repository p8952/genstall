#!/usr/bin/env bash
source /tmp/00-settings.sh

$CHROOT emerge $SOFTWARE

for D in $DAEMONS; do 
	$CHROOT rc-update add $D default
done
