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
	# Check for collision
	if grep -q "^$uuid$" uuid_log.txt; then
		echo "UUID collision detected"
		exit 1
	fi

	# Record UUID and timestamp in log 
	echo "$uuid $(date)" >> uuid_log.txt

	# Output to terminal and file
	echo "$uuid"
	echo "$uuid" >> uuid_output.txt
}


#Function to catagorise content in directory
catagorize_directory() {
	# Iterate Through child  directories 
	
	# Count file types, calculate collective size

	#Find shortest and largest file names

	# output results to terminal and file
	echo "This function is not yer implimented"

}

# Main Function
main(){
# Check arguments
	if [ $# -eq 0 ]; then
	echo "Usage :  $0 <option>"
	exit 1
	
	fi

	# Record PID of script
	echo "Script PID: $$" >> script_log.txt

	# Record script comand
	echo "$(date) -$@" >> script_log.txt

	# Perform action based on option
	case $1 in
	uuid)
		generate_uuid "$2"
		;;

	categorize)
		categorize_directory
		;;
	*)
		echo "Invalid option : $1"
		exit 1
		;;
	esac

	}
# Call main function with arguements
main "$@"


