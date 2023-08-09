#! /bin/bash

rabbitmqUsername=$1
rabbitmqPassword=$2
jdbcUsername=$3
jdbcPassword=$4
# Download Source code
git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Update configuration
cd vprofile-project

# Define the path to the input file and configuration file
input_file="/etc/hosts"
config_file="src/main/resources/application.properties"


# Read the input file and extract the IP address associated with "rabbitmq"
rabbitmq_addr=$(awk '/rabbitmq/ {print $2}' "$input_file")
memcache_addr=$(awk '/memcache/ {print $2}' "$input_file")
ip_address=$(awk '/mariadb/ {print $1}' "$input_file")

# Check if the rabbitmq IP was found in the input file
[ -z "$rabbitmq_addr" ] && { echo "Error: 'rabbitmq' IP not found in the input file."; exit 1; }
[ -z "$memcache_addr" ] && { echo "Error: 'rabbitmq' IP not found in the input file."; exit 1; }

# Update the rabbitmq.address value in the configuration file
sudo sed -i "s/rabbitmq\.address=.*/rabbitmq.address=$rabbitmq_addr/" "$config_file"
sudo sed -i "s/rabbitmq\.username=.*/rabbitmq.username=$rabbitmqUsername/" "$config_file"
sudo sed -i "s/rabbitmq\.password=.*/rabbitmq.password=$rabbitmqPassword/" "$config_file"
sudo sed -i "s/memcached\.active\.host=.*/memcached.active.host=$memcache_addr/" "$config_file"
sudo sed -i "s/jdbc\.username=.*/jdbc.username=$jdbcUsername/" "$config_file"
sudo sed -i "s/jdbc\.password=.*/jdbc.password=$jdbcPassword/" "$config_file"
sudo sed -i "s/db01/$ip_address/g" "$config_file"


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
