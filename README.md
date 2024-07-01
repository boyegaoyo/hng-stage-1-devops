
**This is part of my internship project at HNG to create a script file that accepts a line separated list of strings to create users and group**

Your company has employed many new developers. As a SysOps engineer, write a bash script called create_users.sh that reads a text file containing the employee’s usernames and group names, where each line is formatted as user;groups.

The script should create users and groups as specified, set up home directories with appropriate permissions and ownership, generate random passwords for the users, and log all actions to /var/log/user_management.log. Additionally, store the generated passwords securely in /var/secure/user_passwords.txt.
Ensure error handling for scenarios like existing users and provide clear documentation and comments within the script.
Also write a technical article explaining your script, linking back to HNG

**Requirements:**
Each User must have a personal group with the same group name as the username, this group name will not be written in the text file.
A user can have multiple groups, each group delimited by comma ","
Usernames and user groups are separated by semicolon ";"- Ignore whitespace
e.g.

```
light; sudo,dev,www-data
idimma; sudo
mayowa; dev,www-data
```

**1. Create the necessary directories**


```
sudo mkdir -p /var/secure
sudo touch /var/secure/user_passwords.csv
sudo touch /var/log/user_management.log
sudo chmod 600 /var/secure/user_passwords.csv
sudo chmod 640 /var/log/user_management.log
```
**2. Create create_users.sh**

Run ```touch create_users.sh```

**3. Run the ```chmod +x create_users.sh``` on
create_users.sh to make it executable**

Open the file using ```sudo nano create_users.sh``` and paste in the content of the script.

**3. Prepare the users and groups file**

Create a text file ```user_list.txt``` and paste in

```
light; sudo,dev,www-data
idimma; sudo
mayowa; dev,www-data

```

**4. Run the Script**

```sudo ./create_users.sh user_list.txt```

End. You can just the internship at [HNG Internship](https://hng.tech/internship) and also join the premium [HNG Premium](https://hng.tech/premium)
