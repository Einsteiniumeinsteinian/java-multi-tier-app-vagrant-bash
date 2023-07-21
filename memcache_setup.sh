#!/bin/bash

# Update package list
sudo apt update

# Upgrade Packages
sudo apt upgrade

# Install Memcached
sudo apt install -y memcached

# Start and enable Memcached service
sudo systemctl start memcached
sudo systemctl enable memcached

# Check Memcached service status
sudo systemctl status memcached

# Optionally, configure Memcached to listen on specific interfaces and ports
# Modify the configuration file if needed
# sudo nano /etc/memcached.conf

# Test Memcached
# echo "Testing Memcached..."
# echo -e "set mykey 0 3600 5\r\nhello\r\nget mykey\r\n" | nc localhost 11211

# # Terminate the script after Memcached testing is complete
# exit