#!/bin/bash

#Function to genrate UUID
generate_uuid() {
# Generate UUID based on input type
	case $1 in
	1)
		uuid=$uuid1
		;;
	2)
		uuid=$uuid4
		;;
	
	*)
		echo "Invalid UUID type"
		exit 1
		;;
	esac

	# check for collision
	check_uuid_collision
	#if grep -q "$uuid" uuid_log.txt;  then
		#echo "UUID collision detected"
	#fi	
	# Record UUID and timestamp in log 
	echo "$uuid $(date)" >> uuid_log.txt

	#Output to terminal and file
	echo "$uuid"
	echo "$uuid" >> uuid_output.txt

}
# Function to genrate UUID1
generate_uuid1 () {
	# Generate UUID based on UUID version 1 specifications
	local timestamp=$(date +%s) #local keyword declare variables within functions
	local nanoseconds=$(date +%N)
	local random_hex=$(openssl rand -hex 6)

# Debugging: Print out the values of variables
    #echo "Timestamp: $timestamp"
    #echo "Nanoseconds: $nanoseconds"
    echo "Random Hex: $random_hex"

	# Format UUID1 according to the specifications
	local uuid="${timestamp}-${nanoseconds}-${random_hex}"
	echo "$uuid1" # Printing UUID1
}

# Function to genrate UUID4
generate_uuid4() {
	# Generate UUID based on UUID version 4 specifications
	local uuid4_hex=$(openssl rand -hex 16)
	# Manipulate bits to set the version (4) and variant (8, 9, or A)
	uuid4_hex=${uuid4_hex:0:12}4${uuid4_hex:13:3}8${uuid4_hex:16:1}${uuid4_hex:17:3}
    # Format UUID4 with hyphens
    local uuid4=$(echo "${uuid4_hex}" | sed 's/\(..\)/\1-/g')
    echo "${uuid4}"
}

# Function to check if UUID exists in file and if collision occurred
check_uuid_collision() {
 local uuid=$1
	local file=$2

    if grep -q "$uuid" "$file"; then
       echo "Collision occurred for UUID: $uuid"
      return 1
    else
        return 0
   fi
}

# Function to log UUID creation date
#log_uuid_creation_date() {
   # local uuid=$1
    #local logfile="uuid_log.txt"

    #echo "$(date '+%Y-%m-%d %H:%M:%S') - $uuid" >> "$logfile"
#}


# Main function
main() {
	 # Validate script variable inputs
    if [[ $# -ne 0 ]]; then   # if any arguments are prrovided exits with code 1
        echo "Error: This script does not take any arguments."
        exit 1
    fi
	#------------------------------------------------------------------
    # Generate UUID1
    local uuid1=$(generate_uuid1)
    if [ $? -ne 0 ]; then
        echo "Error generating UUID1." # displays an error message and exits
        exit 2
    fi
    #log_uuid_creation_date "$uuid1"
    #check_uuid_collision "$uuid1" "uuid_log.txt" || exit 3
	
	#echo "$uuid $(date)" >> uuid_log.txt   # Record UUID and timestamp in log 
	
	#-------------------------------------------------------------------
    # Generate UUID4
    local uuid4=$(generate_uuid4)
    if [ $? -ne 0 ]; then   #
        echo "Error generating UUID4." # displays an error message and exits
        exit 4
    fi
    #log_uuid_creation_date "$uuid4"
   # check_uuid_collision "$uuid4" "uuid_log.txt" || exit 5

	#------------------------------------------------------------------
	
    echo "UUID1: $uuid1"
    echo "UUID4: $uuid4"
}

# Call main function
main "$@"

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


