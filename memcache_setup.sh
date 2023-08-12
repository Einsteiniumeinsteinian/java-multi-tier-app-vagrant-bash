#!/bin/bash

# Update package list
sudo apt update
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
sudo sed -i 's/-l 127.0.0.1/-l 0.0.0.0/' "/etc/memcached.conf"
sudo systemctl restart memcached
sudo systemctl status memcached
