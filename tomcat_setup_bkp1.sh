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

Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-arm64
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

# Enabling the firewall and allowing port 8080 to access tomcat
# sudo systemctl start ufw
# sudo systemctl enable ufw
# sudo ufw allow 8080

# Reload ufw
sudo ufw reload

# Download Source code
git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Update configuration
cd /tmp/vprofile-project

# Define the path to the input file and configuration file
input_file="/etc/hosts"
config_file="/tmp/vprofile-project/src/main/resources/application.properties"

# Read the input file and extract the IP address associated with "rabbitmq"
rabbitmq_addr=$(awk '/rabbitmq/ {print $2}' "$input_file")
memcache_addr=$(awk '/memcache/ {print $2}' "$input_file")

# Check if the rabbitmq IP was found in the input file
[ -z "$rabbitmq_addr" ] && { echo "Error: 'rabbitmq' IP not found in the input file."; exit 1; }
[ -z "$memcache_addr" ] && { echo "Error: 'rabbitmq' IP not found in the input file."; exit 1; }

# Update the rabbitmq.address value in the configuration file
sed -i "s/rabbitmq\.address=.*/rabbitmq.address=$rabbitmq_addr/" "$config_file"
sed -i "s/memcached\.active\.host=.*/memcached.active.host=$memcache_addr/" "$config_file"
sed -i "s/rabbitmq\.username=.*/rabbitmq.username=test/" "$config_file"
sed -i "s/rabbitmq\.password=.*/rabbitmq.password=mytestpassword/" "$config_file"

echo "Updated rabbitmq.address in $config_file with IP: $rabbitmq_addr"
echo "Updated rabbitmq.address in $config_file with IP: $memcache_addr"

# Build code
# Run the below command inside the repository (vprofile-project)
mvn install

# Deploy artifact
# Stop Tomcat before deploying the artifact
sudo systemctl stop tomcat

# Remove any previous deployments from Tomcat webapps directory
sudo rm -rf /opt/tomcat/webapps/ROOT*

# Copy the WAR file to Tomcat webapps directory with the name ROOT.war
sudo cp target/vprofile-v2.war /opt/tomcat/webapps/ROOT.war

# Start Tomcat
sudo systemctl start tomcat

# Set proper ownership to Tomcat webapps directory
sudo chown tomcat:tomcat /opt/tomcat/webapps -R

# Restart Tomcat
sudo systemctl restart tomcat

