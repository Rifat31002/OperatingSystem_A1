#!/bin/bash

# Function to genrate UUID1
generate_uuid1 () {
    # Generate UUID based on UUID version 1 specifications
    local timestamp=$(date +%s)             # Get current timestamp in seconds since Unix epoch
    local nanoseconds=$(date +%N)           # Get nanoseconds portion of current time
    
    # Get the MAC address of the host machine
    local mac_address=$(ip link show | grep -oE 'ether [[:alnum:]:]+' | awk '{print $2}')
    local uuid="${timestamp}-${nanoseconds}-${mac_address}" # Format UUID1 according to specifications  # Format UUID1 according to the specifications
    
    echo  "UUID version 1: $uuid"            # Print UUID version 1 to the terminal
    #echo "$uuid" >> uuid_output.txt      # Save UUID version 1 to a file
    # Debugging: Print out the values of variables
            #echo "Timestamp: $timestamp"
            #echo "Nanoseconds: $nanoseconds"
            #echo "Random Hex: $random_hex"
}
# Function to generate UUID2
generate_uuid2() {		# Distributed Computing Environment (DCE)
    local timestamp=$(date +%s)         # Get current timestamp in seconds simce Unix epoch
    local lower_timestamp=$(( $timestamp & 0xFFFFFFFF ))        # Get the lower 32 bits of the timestamp
    local mac_address=$(ip link show | grep -oE 'ether [[:alnum:]:]+' | awk '{print $2}')       # Get the MAC address of the host machine
    local hostname=$(hostname)           # Get the domain name or hostname
    local uuid=$(printf "%X-%X-%s-%s" $timestamp $lower_timestamp $mac_address $hostname)      # Combine timestamp, local identifier, MAC address, and hostname
    
    echo "UUID version 2: $uuid"        # Print UUID version 2 to the terminal
}

# Function to genrate UUID4
generate_uuid4() {          # Generate UUID based on UUID version 4 specifications
    local random_hex=$(dd if=/dev/random count=16 bs=1 2>/dev/null | xxd -ps)       # Generate 128 random bits
    local byte7=${random_hex:12:2}  # Manipulate bits to set the version (4)Take the 7th byte and perform an AND operation with 0x0F to clear out the high nibble.
    
    byte7=$(( 0x$byte7 & 0x0F ))
    byte7=$(( $byte7 | 0x40 ))      # OR it with 0x40 to set the version number to 4.
    
    local byte9=${random_hex:24:2}  # Next, take the 9th byte 
    
    byte9=$(( 0x$byte9 & 0x3F ))    #and perform an AND operation with 0x3F 
    byte9=$(( $byte9 | 0x80 ))      #and then OR it with 0x80.

    # Constructing the modified random hex
    local modified_hex="${random_hex:0:24}$(printf "%02X" $byte7)${random_hex:14:8}$(printf "%02X" $byte9)${random_hex:26}"
    local uuid_hex=$(echo "$modified_hex" | sed 's/\(..\)/\1-/g')   # Convert to hexadecimal representation
    local uuid=$(echo "${uuid_hex^^}" | sed 's/-$//')       # Convert to uppercase and remove trailing hyphen

    echo "UUID version 4: $uuid"    # Print UUID version 4 to the terminal
}
# Function to check if UUID exists in file and if collision occurred
check_uuid_collision() {
    local uuid=$1
    local log_file=$2

    if grep -q "^$uuid$" "$log_file"; then
      return 1
    else
        return 0
   fi
}

#Function to genrate UUID
generate_uuid() {     

	local uuid=$1
    local uuid_type=$1
    local log_file="uuid_log.txt"
    local max_attempts=3
    local attempt=1

    case $uuid_type in	# Generate UUID based on input type
        1)
            generate_uuid1
            ;;
        2)
            generate_uuid2
            ;;
		4)
			generate_uuid4
            ;;
        *)
            echo "Invalid UUID type"
            exit 1
            ;;
    esac

    while (( attempts <= max_attempts )); do		# check if UUID exists in file and if collision occurred
        if ! check_uuid_collision  "$uuid" "$log_file"; then	# Check for collision
            echo "$uuid $(date)">>"$log_file"		# Record UUID and timestamp in log
            echo "$uuid"				# Output to terminal 
            echo "$uuid">> uuid_output.txt
            return 0
        else
            echo "Collision detected for UUID : $uuid"
            (( attempt++ ))
            uuid=$(generate_uuid $uuid_type) # Retry generating UUID
        fi
    done

    echo "Maximum attempts reached. Exiting..."
    exit 1

}

# Function to categorize content in directory
categorie_directory() {
   
    for dir in _Directory/*/; do   # Iterate through child directories
        dir_name=$(basename "$dir")     # Get directory name
       
        # Count files of each type and calculate size
        file_types=$(find "$dir" -type f | awk -F. '{print $NF}' | sort | uniq -c)
        total_size=$(du -sh "$dir" | awk '{print $1}') # Human readable formate
        permissions=$(ls -l "$dir")
        file_info=$(ls -l "$dir" | awk '{print $1,$3,$4,$5,$6,$7,$8,$9}')
        
        # Find shortest and largest file names
        shortest_file=$(find "$dir" -type f -printf "%f\n" | awk '{print length, $0}' | sort -n | head -n 1 | cut -d ' ' -f 2-)
        longest_file=$(find "$dir" -type f -printf "%f\n" | awk '{print length, $0}' | sort -rn | head -n 1 | cut -d ' ' -f 2-)
        
        # Output results to terminal 
        echo "Directory: $dir_name"     # output directory name to terminal
        echo "Permissions | Owner | Group | Size | Last Modified | Filename |"
        echo "$permissions"
        echo "Total size : $total_size"
        # Output shortest and longest file names to terminal
        echo "Shortest file name: $shortest_file"
        echo "Longest file name: $longest_file"
         echo " "         # Add a blank line for separation
        
    done
}
# Function to record user login information and script commands
record_logs() {
    # Get current date, time, history & Get user login information
    local script_commands=$(history | tail -n +2 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' | sed '/^record_logs$/d')  # Get script commands from history
    local log_entry="[$(date "+%Y-%m-%d %H:%M:%S") User login information: $(whoami) \n" # Create log entry
    echo -e "$log_entry" >> script_log.txt      # Append log entry to log file
    echo -e "Log entry recorded !\n$log_entry"   # Print log entry to terminal
    # Append script commands to log file
    history | tail -n +2 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' >> script_log.txt
}

  
create_man_page() {
    # Create man page content
    local man_page_content="
    .TH UTILITY_SCRIPT 1 \"\" \"Utility Script Manual\"
    .SH NAME
    utility_script \- Bash utility script
    .SH SYNOPSIS
    utility_script [OPTIONS]
    .SH DESCRIPTION
    This script is a Bash utility that can generate UUIDs, categorize content in directories, and record user login information and script commands.
    .SH OPTIONS
    .B record-logs
    Record user login information and script commands.
    .B create-man-page
    Create a man page for the utility script.
    .SH AUTHOR
    Your Name
    "
    echo "$man_page_content" > utility_script.1     # Create man page file
    gzip utility_script.1       # Compress man page file
}

# Main function
main() {
    local attempts=3
	
    #prompt user to enter a UUID type to type.
    while [[ $attempts -gt 0 ]]; do
        read -p "Enter 1 for UUID version 1, 2 for UUID version 2 , 4 for UUID version 4 & 3 for categorise : " uuid_type
        case $uuid_type in   
			1|2|4)
                generate_uuid $uuid_type
				break
                ;;
            3)
                categorise_directory
                echo "$catagorise_directory " >> directory_output.txt
                break
                ;;
            *)
                echo "Invalid option. Usage: $0 {1 | 2 | 3 | 4}"
                ((attempts--))
                ;;
        esac
    done
    echo "Maximum attempts reached. Exiting..."
	record_logs
    # Record UUID and timestamp in log 
	# Record script command
    echo "$(date) $(whoami) -Script PID: $$" >> script_log.txt  # Record PID of script with user

    # Append script commands to log file
    history | tail -n +2 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' >> script_log.txt
}

# Check if an argument is passed to the script
if [[ $# -eq 1 ]]; then
    case $1 in
        record-logs)
            record_logs
            ;;
        man-page)
            create_man_page
            ;;
        *)
            echo "Invalid argument. Usage: $0 {record-logs | man-page}"
            ;;
    esac
else
    main "$@"
fi