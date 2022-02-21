#!/bin/bash

while getopts ":hs:" option
do
	case $option in
		h)
			echo "File format: login;password"
			echo "To change default delimiter use -s DELIMITER"
			exit 0
			;;
		s)	
			echo "$3"
			sed "s/$OPTARG/:/g" $3 | awk -F ":" '{system("useradd "$1); system("echo "$0 "| chpasswd")}'
			exit 0
			;;
		*)
			echo "Unknown args"
			exit 1
			;;

	esac
done
awk -F ":" '{system("useradd "$1); system("echo "$0 "| chpasswd")}' $1 
exit 0

