#!/bin/bash

# Function to genrate UUID1
generate_uuid1 () {
	# Generate UUID based on UUID version 1 specifications
	timestamp=$(date +%s)
	nanoseconds=$(date +%N)
	random_hex=$(openssl rand -hex 6)

	# Format UUID1 according to the specifications
	uuid="${timestamp}-${nanoseconds}-${random_hex}"
	echo "$uuid1"
}

# Function to genrate UUID4
generate_uuid4() {
	# Generate UUID based on UUID version 4 specifications
	uuid4_hex=$(openssl rand -hex 16)
	# Manipulate bits to set the version (4) and variant (8, 9, or A)
	uuid4_hex=${uuid4_hex:0:12}4${uuid4_hex:13:3}8${uuid4_hex:16:1}${uuid4_hex:17:3}
    # Format UUID4 with hyphens
    uuid4=$(echo "${uuid4_hex}" | sed 's/\(..\)/\1-/g')
    echo "${uuid4}"
}

# Main function
main() {
    # Generate UUID1
    echo "UUID1: $(generate_uuid1)"
    
    # Generate UUID4
    echo "UUID4: $(generate_uuid4)"
}

# Call main function
main

# Function to genrate UUID
# generate_uuid() {
	# Generate UUID based on user imput.
	#case $1 in
	#1)
	# UUID Version 1 : Time stamp based UUID
		#uuid=$(date +%s)-$(date +%N)-$(openssl rand -hex 6)
		#uuid=$(cat /proc/sys/kernel/random/uuid)
		#;;
	#2)
	# UUID version 2:Time-based (LSB) + user ID,  DCE Security
	# Generating a random UUID using random numbers
	#	uuid=$(openssl rand -hex 16)
		#echo "UUID version 2 is not supported"
           # exit 1
		#;;
	#3)
	# UUID version 3: Name-based UUID with MD5 hashing
        # Not implemented in this example
        #echo "UUID version 3 is not supported"
        #exit 1
		#uuid=$(uuidgen)
		#;;
	#4)
	# PRNG [1 trillion UUIDarg1
	#s for a chance of 2 repeats]
		#uuid=$(uuid -v  4)
		#;;
	#5)
	# UUID version 5: Name-based UUID with SHA-1 hashing
		#uuid=$(uuid -v 5)
		#;;
	#*)
		#echo "Invalid UUID type"
		#exit 1
		#;;
	#esac
	# Check for collision
	#if grep -q "^$uuid$" uuid_log.txt; then
		#echo "UUID collision detected"
		#exit 1
	#fi

	# Record UUID and timestamp in log 
	#echo "$uuid $(date)" >> uuid_log.txt

	# Output to terminal and file
	#echo "$uuid"
	#echo "$uuid" >> uuid_output.txt
#}


#Function to catagorise content in directory
catagorize_directory() {
	# Iterate Through child  directories 
	
	# Count file types, calculate collective size

	# Find shortest and largest file names
	
	# Output results to terminal and file
	echo "This function is not yet implimented"

}

# Main Function
#main(){
# Check arguments
	#if [ $# -eq 0 ]; then
	#echo "Usage :  $0 <option>"
	#exit 1
	
	#fi

	# Record PID of script
	#echo "Script PID: $$" >> script_log.txt

	# Record script comand
	#echo "$(date) -$@" >> script_log.txt

	# Perform action based on option
	#case $1 in
	#uuid)
		#generate_uuid "$2"
		#;;

	#categorize)
		#categorize_directory
		#;;
	#*)
		#echo "Invalid option : $1"
		#exit 1
		#;;
	#esac

	#}
# Call main function with arguements
#'main "$@"


