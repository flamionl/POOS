#!/bin/bash

if test -f "$1"; then
	echo "$1 exists."
	file $1
fi
