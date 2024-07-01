#!/bin/bash  # Specifies the script interpreter

# Log file and password file locations
LOGFILE="/var/log/user_management.log"  # Sets the log file path
PASSWORD_FILE="/var/secure/user_passwords.csv"  # Sets the password file path

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $LOGFILE  # Logs messages with timestamp to LOGFILE
}

# Function to create user and assign groups
create_user() {
    local username=$1  # Assigns the first argument to username
    local groups=$2  # Assigns the second argument to groups

    # Create a personal group for the user
    if ! getent group "$username" > /dev/null; then  # Checks if the group exists
        sudo groupadd "$username"  # Creates a group with the user's name
        log_message "Group $username created."  # Logs group creation
    else
        log_message "Group $username already exists."  # Logs if the group already exists
    fi

    # Create user with the personal group
    if ! id "$username" &>/dev/null; then  # Checks if the user exists
        sudo useradd -m -g "$username" -G "$groups" "$username"  # Creates the user with the personal group and additional groups
        log_message "User $username created and added to groups: $groups."  # Logs user creation and group assignment
        
        # Generate a random password
        password=$(openssl rand -base64 12)  # Generates a random password
        echo "$username,$password" | sudo tee -a $PASSWORD_FILE  # Saves the username and password to PASSWORD_FILE

        # Set the password for the user
        echo "$username:$password" | sudo chpasswd  # Sets the password for the user
        log_message "Password set for user $username."  # Logs password setting
    else
        log_message "User $username already exists."  # Logs if the user already exists
    fi
}

# Check if the input file is provided
if [ $# -ne 1 ]; then  # Checks if exactly one argument is provided
    echo "Usage: $0 <user_list_file>"  # Prints usage information
    exit 1  # Exits the script with an error code
fi

USER_LIST_FILE=$1  # Assigns the first argument to USER_LIST_FILE

# Read the file line by line
while IFS=';' read -r username groups; do  # Reads each line of USER_LIST_FILE, splitting by semicolon
    # Remove leading and trailing whitespace
    username=$(echo "$username" | xargs)  # Trims whitespace from username
    groups=$(echo "$groups" | xargs)  # Trims whitespace from groups
    
    # Replace commas with spaces for the groups
    groups=$(echo "$groups" | sed 's/,/ /g')  # Replaces commas with spaces in groups

    # Create user and assign groups
    create_user "$username" "$groups"  # Calls the create_user function

done < "$USER_LIST_FILE"  # Specifies the file to read from

log_message "User creation script completed."  # Logs script completion

exit 0  # Exits the script
