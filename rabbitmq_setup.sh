#!/bin/bash

# Update package list
sudo apt-get update

# Install prerequisites
sudo apt-get install -y gnupg2

# Add RabbitMQ signing key
wget -O - 'https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey' | sudo apt-key add -

# Add the RabbitMQ APT repository
echo 'deb http://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ bionic main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list

# Update package list again
sudo apt-get update

# Add the Erlang Solutions repository (PPA)
sudo apt-get install -y gnupg
wget -O - https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
echo "deb https://packages.erlang-solutions.com/ubuntu $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list

# Update package lists
sudo apt-get update

# Install RabbitMQ
sudo apt-get install -y rabbitmq-server

# Enable the RabbitMQ management plugin (web interface)
sudo rabbitmq-plugins enable rabbitmq_management

# Start RabbitMQ service
sudo systemctl start rabbitmq-server

# Enable RabbitMQ service on boot
sudo systemctl enable rabbitmq-server

# Wait for RabbitMQ to start (you may need to adjust the sleep time based on your system)
sleep 10

# Create a new user named "test" with full administrative privileges
sudo rabbitmqctl add_user test mytestpassword
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

