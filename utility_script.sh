#!/bin/bash

#Function to genrate UUID
generate_uuid() {
	# Generate UUID based on input type
	case $1 in
	1)
		uuid=$(cat /proc/sys/kernel/random/uuid)
		;;
	2)
		uuid=$(openssl rand -hex 16)
		;;
	3)
		uuid=$(uuidgen)
		;;
	4)
		uuid=$(uuid -v  4)
		;;
	5)
		uuid=$(uuid -v 5)
		;;
	*)
		echo "Invalid UUID type"
		exit 1
		;;
	esac

	# check for collision
	if grep -q "$uuid" uuid_log.txt;  then
		echo "UUID collision detected"
	fi	
	# Record UUID and timestamp in log 
	echo "$uuid $(date)" >> uuid_log.txt

	#Output to terminal and file
	echo "$uuid"
	echo "$uuid" >> uuid_output.txt
}
