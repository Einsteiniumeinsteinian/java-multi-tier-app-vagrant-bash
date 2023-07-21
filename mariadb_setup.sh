#!/bin/bash

# Update package lists and install required packages
sudo apt update

# Install mariadb dependencies and dependecies
sudo apt install git zip unzip mariadb-server -y

# Start and enable mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Run mysql secure installation script
sudo mysql_secure_installation <<EOF

Y
admin123
admin123
Y
Y
Y
Y
EOF

# Set DB name and users
sudo mysql -u root -padmin123 <<EOF
create database accounts;
grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';
FLUSH PRIVILEGES;
exit;
EOF

# Download Source code & Initialize Database.
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
sudo mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Check if the tables are created successfully
sudo mysql -u root -padmin123 accounts -e "show tables;"

# Restart mariadb-server
sudo systemctl restart mariadb
