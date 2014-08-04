#!/usr/bin/env bash

for F in genstall.d/*; do
	if [[ ! "$F" =~ 'vagrant' ]]; then
		bash "$F"
	fi
done
