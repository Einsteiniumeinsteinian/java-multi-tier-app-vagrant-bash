#!/bin/bash

# Update OS with the latest patches
sudo apt update
# sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Remove the default Nginx conf
sudo rm -rf /etc/nginx/sites-available/*
sudo rm -rf /etc/nginx/sites-enabled/* 

# Create an Nginx conf file with the given content
cat <<EOF | sudo tee /etc/nginx/sites-available/vproapp
upstream vproapp {
    server tomcat:8080;
}

server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOF
# # Create a link to activate the website
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# Restart Nginx
sudo systemctl restart nginx

