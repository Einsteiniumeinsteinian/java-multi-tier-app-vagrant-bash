#! /bin/bash
source ./variables.env

function print_blue() {
  echo -e "\e[34m$1\e[0m"
}

function remove_unnecessary_files (){
  (
    cd $application_directory
    rm -rf Jenkinsfile .git ansible vagrant
  )
}

validate_variables() {
  local valid_chars='^[A-Za-z0-9_-]+$'

  
  [[ -z "$application_directory" ]] && echo "Application directory cannot be empty" && exit 1
  [[ ! "$application_directory" =~ $valid_chars ]] && echo "Application directory contains invalid characters" && exit 1

  for var in jdbcUsername jdbcPassword rabbitmqUsername rabbitmqPassword; do
    [[ -z "${!var}" ]] && echo "$var cannot be empty" && exit 1
  done

  for ip_var in mariadb_ip memcache_ip rabbitmq_ip tomcat_ip nginx_ip; do
    [[ -z "${!ip_var}" ]] && echo "$ip_var cannot be empty" && exit 1
  done

  for hostname_var in mariadb_hostname memcache_hostname rabbitmq_hostname tomcat_hostname nginx_hostname; do
    [[ -z "${!hostname_var}" ]] && echo "$hostname_var cannot be empty" && exit 1
    [[ ! "${!hostname_var}" =~ $valid_chars ]] && echo "$hostname_var contains invalid characters" && exit 1
  done

  return 0
}

function edit_config_file (){
local config_file=$1
local edit
sed -i "s/rabbitmq\.address=.*/rabbitmq.address=$rabbitmq_ip/" "$config_file"
sed -i "s/rabbitmq\.username=.*/rabbitmq.username=$rabbitmqUsername/" "$config_file"
sed -i "s/rabbitmq\.password=.*/rabbitmq.password=$rabbitmqPassword/" "$config_file"
sed -i "s/memcached\.active\.host=.*/memcached.active.host=$memcache_ip/" "$config_file"
sed -i "s/jdbc\.username=.*/jdbc.username=$jdbcUsername/" "$config_file"
sed -i "s/jdbc\.password=.*/jdbc.password=$jdbcPassword/" "$config_file"
sed -i "s/db01/$mariadb_ip/g" "$config_file"
}

config_file="$application_directory/src/main/resources/application.properties"

#check variables
validate_variables && print_blue "Success!!"

# Read and source the variable.env file
print_blue "Creating and Downloading Files into $app_directoy"

#clone repo
print_blue "Cloning Directory"
git clone -b main --depth 1 https://github.com/hkhcoder/vprofile-project.git $application_directory 2>/dev/null
clone_exit_code=$?
[[ $clone_exit_code -ne 0 && ! -d "$application_directory" ]] && { echo "Clone failed"; exit 61; }

# Remove files and directories that are not in the 'files' array
print_blue "Removing unneccesary Files and Directory"
remove_unnecessary_files "$application_directory" || { echo "Failed to remove files"; exit 12; }
print_blue "Done!!"

# print_blue "Configuring Variable File"
print_blue "Editing Config file"
edit_config_file "$config_file" && print_blue "Successful"|| { echo "Failed to edit config"; exit 13; }
print_blue "Done"

vagrant up
