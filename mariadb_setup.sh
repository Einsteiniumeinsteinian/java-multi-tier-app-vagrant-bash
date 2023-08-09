#!/bin/bash

# Function to print colored text
print_blue() {
  echo -e "\e[34m$1\e[0m"
}

# Function to run mysql_secure_installation non-interactively
function secure_mysql_installation() {
  sudo mysql_secure_installation <<EOF
Y
$1
$1
Y
Y
Y
Y
EOF
}

mySqlUsername=$1
mySqlPassword=$2
root_password=$2

# Install MariaDB Package
sudo apt-get update
sudo apt-get install git mariadb-server -y

# Starting & enabling mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Bind Address to make it publicly accessible
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
# sudo sed -i 's/-l 127.0.0.1/-l 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb

# Run mysql secure installation script non-interactively with specified root password
secure_mysql_installation "$root_password"

# Set DB name and users
sudo mysql -u root -p"$root_password" <<EOF
create database accounts;
grant all privileges on accounts.* TO '$mySqlUsername'@'%' identified by '$root_password';
FLUSH PRIVILEGES;
exit
EOF

# Download Source code & Initialize Database.
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
sudo mysql -u root -p"$root_password" accounts < src/main/resources/db_backup.sql

# Check if the tables are created
sudo mysql -u root -p"$root_password" accounts -e "show tables;"

# Restart mariadb-server
sudo systemctl restart mariadb
