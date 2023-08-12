#!/bin/bash

rabbitmqUsername=$1
rabbitmqPassword=$2

# Update package list
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
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user $rabbitmqUsername $rabbitmqPassword
sudo rabbitmqctl set_user_tags $rabbitmqUsername administrator
sudo rabbitmqctl set_permissions -p / $rabbitmqUsername ".*" ".*" ".*"
sudo systemctl restart rabbitmq-server
