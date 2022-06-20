#!/bin/bash

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then
        echo "Enter database name!"
        read dbname

        echo "Creating new MySQL database..."
        mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
        echo "Database successfully created!"

        echo "Enter database user!"
        read username

        echo "Enter the PASSWORD for database user!"
        echo "Note: password will be hidden when typing"
        read -s userpass

        echo "Creating new user..."
        mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
        echo "User successfully created!"

        echo "Granting ALL privileges on ${dbname} to ${username}!"
        mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
        mysql -e "FLUSH PRIVILEGES;"
        echo "You're good now :)"
        exit

# If /root/.my.cnf doesn't exist then it'll ask for root password
else
        echo "Please enter root user MySQL password!"
        echo "Note: password will be hidden when typing"
        read -s rootpasswd

        echo "Enter database name!"
        read dbname

        echo "Creating new MySQL database..."
        mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
        echo "Database successfully created!"

        echo "Enter database user!"
        read username

        echo "Enter the PASSWORD for database user!"
        echo "Note: password will be hidden when typing"
        read -s userpass

        echo "Creating new user..."
        mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
        echo "User successfully created!"

        echo "Granting ALL privileges on ${dbname} to ${username}!"
        mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
        mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
        echo "You're good now :)"
        exit
fi
