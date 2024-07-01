
***This is part of my internship project at HNG***

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