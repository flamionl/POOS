#!/bin/bash

while getopts ":al:" option
do
	case $option in
		a)
			find /var/log -type f -exec cat {} +
			exit 0
			;;
		l)
			cat $OPTARG
			exit 0
			;;
		*)
			echo "Unknown args"
			exit 1
			;;
	esac
done
ls -ARp /var/log 2>/dev/null | grep -Ev '(/|^\s*$)'
exit 0
