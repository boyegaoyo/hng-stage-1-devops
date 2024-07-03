#!/bin/bash

# Log file and password file locations
LOGFILE="/var/log/user_management.log"  # Location for logging user management activities
PASSWORD_FILE="/var/secure/user_passwords.txt"  # Location for storing user passwords securely

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a $LOGFILE  # Logs messages with timestamp to logfile
}

# Function to create user and assign groups
create_user() {
    local username="${1%%;*}"  # Extract username from input line
    local groups="${1#*;}"     # Extract groups from input line

    # Create a personal group for the user if it doesn't exist
    if ! getent group "$username" > /dev/null; then
        sudo groupadd "$username"  # Creates a group with username
        log_message "Group $username created."  # Logs group creation
    else
        log_message "Group $username already exists."  # Logs if group already exists
    fi

    # Check if the user exists
    if id "$username" &>/dev/null; then
        log_message "User $username already exists. Ensuring group memberships are correct."  # Logs user existence

        # Loop through each group, check existence, and add user
        for group in "${groups//,/ }"; do
          if ! getent group "$group" > /dev/null; then
            sudo groupadd "$group"  # Creates group if it doesn't exist
            log_message "Group $group created."  # Logs group creation
          fi
          sudo usermod -a -G "$group" "$username" # Add user to the group
          if [ $? -eq 0 ]; then
            log_message "User $username added to group $group."  # Logs user added to group
          else
            log_message "Failed to add user $username to group $group."  # Logs failure to add user to group
          fi
        done
    else
        # User does not exist, create user with specified groups
        sudo useradd -m -g "$username" -G "$groups" "$username"  # Creates user with specified groups
        if [ $? -eq 0 ]; then
            log_message "User $username created and added to groups: $groups."  # Logs user creation
            password=$(openssl rand -base64 12)  # Generates a random password
            echo "$username:$password" | sudo tee -a $PASSWORD_FILE  # Stores username and password securely
            echo "$username:$password" | sudo chpasswd  # Sets the password for the user
            log_message "Password set for user $username."  # Logs password setting
        else
            log_message "Failed to create user $username."  # Logs failure to create user
        fi
    fi
}

# Check if the input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <user_list_file>"
    exit 1
fi

USER_LIST_FILE=$1

# Read the file line by line
while IFS=';' read -r username groups; do
    # Remove leading and trailing whitespace
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)
    
    # Split groups by commas
    groups=$(echo "$groups" | tr ',' ' ')

    # Create user and assign groups
    create_user "$username" "$groups"

done < "$USER_LIST_FILE"

log_message "User creation script completed."  # Logs completion of user creation script

exit 0  # Exits script with success status
