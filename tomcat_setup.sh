#!/bin/bash

# Update the system to ensure it's up-to-date
sudo apt update
sudo apt upgrade


# Install Dependencies (OpenJDK 11, git, maven, wget)
sudo apt install -y openjdk-11-jdk openjdk-11-jre git maven wget

# Change directory to /tmp
cd /tmp/

# Create a dedicated Tomcat user and group for security purposes
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

# Download the latest stable version of Tomcat and move it to /opt directory
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz
rm -rf /opt/tomcat
sudo mv apache-tomcat-9.0.75 /opt/tomcat

# Make tomcat user the owner of tomcat home dir
sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod g+x /opt/tomcat/conf

# Setup systemctl command for tomcat service
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_Home=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10 
Restart=always

[Install]

WantedBy=multi-user.target
EOF

# Reload systemctl daemon
sudo systemctl daemon-reload

# Start and enable tomcat service
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo service tomcat status
