#! /bin/bash

rabbitmqUsername=$1
rabbitmqPassword=$2
jdbcUsername=$3
jdbcPassword=$4
application_directory=$5

# Update configuration
cd $application_directory

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
