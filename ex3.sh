#!/bin/bash

while getopts "abc" option
do
	case $option in 
		a)
			echo "Option a"
			;;
		b)
			echo "Option b"
			;;
		c)
			echo "Option c"
			;;
		*)
			echo "Unknow args"
			exit 1
			;;
	esac
done
