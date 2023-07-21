#!/bin/bash

# Update package information
sudo apt-get update

# Upgrate package information
sudo apt-get upgrade

# Install MySQL Server
sudo apt-get install -y mysql-server

# Start the MySQL service
sudo service mysql start

# Check the service 
sudo service mysql status
