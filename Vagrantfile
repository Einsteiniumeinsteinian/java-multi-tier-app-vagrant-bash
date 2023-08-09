# Vagrantfile
# Helper method to read variables from the file
def read_variables_from_file
  File.readlines("variables.env").each do |line|
    key, value = line.strip.split('=')
    ENV[key] = value if key && value
  end
end

# Call the helper method to read the variables
read_variables_from_file

Vagrant.configure("2") do |config|
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.vm.provider "virtualbox"

    config.vm.define "db02" do |mariadb|
        mariadb.vm.box = "ubuntu/focal64"
        mariadb.vm.hostname = "mariadb"
        mariadb.vm.network "private_network", ip: "192.168.56.33"
        # mariadb.vm.network "private_network", type: "dhcp"
        mariadb.vm.provision "shell" do |shell|
       # Pass the variables to the provision script
         shell.args = [
          ENV['jdbcUsername'],
          ENV['jdbcPassword']
      ]
    shell.path = "mariadb_setup.sh"
      end
    end

    config.vm.define "mc02" do |memcache|
        memcache.vm.box = "ubuntu/focal64"
        memcache.vm.hostname = "memcache"
        memcache.vm.network "private_network", ip: "192.168.56.4"
        # memcache.vm.network "private_network", type: "dhcp"
        memcache.vm.provision "shell", path: "memcache_setup.sh"
    end

    config.vm.define "rmq02" do |rabbitmq|
        rabbitmq.vm.box = "ubuntu/focal64"
        rabbitmq.vm.hostname = "rabbitmq"
        rabbitmq.vm.network "private_network", ip: "192.168.56.9"
        rabbitmq.vm.provision "shell" do |shell|
       # Pass the variables to the provision script
         shell.args = [
          ENV['rabbitmqUsername'],
          ENV['rabbitmqPassword']
      ]
         shell.path = "rabbitmq_setup.sh"
      end
        
    end

    config.vm.define "app02" do |tomcat|
        tomcat.vm.box = "ubuntu/focal64"
        tomcat.vm.hostname = "tomcat"
        tomcat.vm.network "private_network", ip: "192.168.56.3"
        tomcat.vm.provision "shell", path: "tomcat_setup.sh"
        if $? == 0
          tomcat.vm.provision "shell" do |shell|
       # Pass the variables to the provision script
         shell.args = [
          ENV['rabbitmqUsername'],
          ENV['rabbitmqPassword'],
          ENV['jdbcUsername'],
          ENV['jdbcPassword']
      ]
         shell.path = "app_setup.sh"
      end
        else
          puts "Script 1 failed. Skipping script 2."
        end
    end

    config.vm.define "web02" do |nginx|
        nginx.vm.box = "ubuntu/focal64"
        nginx.vm.hostname = "nginx"
        nginx.vm.network "private_network", ip: "192.168.56.2"
        nginx.vm.provision "shell", path: "nginx_setup.sh"
    end
end 
