#!/bin/bash

awk -F : '{
if ($3>500)
	print $1":"$7
}' /etc/passwd
