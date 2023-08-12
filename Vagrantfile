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
    
    
    # Specify the default private key for SSH authentication

    config.vm.define "db02" do |mariadb|
        mariadb.vm.box = "ubuntu/focal64"
        mariadb.vm.hostname = ENV["mariadb_hostname"]
        mariadb.vm.network "private_network", ip: ENV["mariadb_ip"]
        # config.vm.synced_folder "./application-directory", "/home/vagrant/application-directory", type: "rsync"
        config.vm.synced_folder "./#{ENV['application_directory']}", "/home/vagrant/#{ENV['application_directory']}", type: "rsync"
        mariadb.vm.provision "shell" do |shell|
       # Pass the variables to the provision script
         shell.args = [
          ENV['jdbcUsername'],
          ENV['jdbcPassword'],
          ENV['application_directory'],
      ]
    shell.path = "mariadb_setup.sh"
      end
    end

    config.vm.define "mc02" do |memcache|
        memcache.vm.box = "ubuntu/focal64"
        memcache.vm.hostname = ENV["memcache_hostname"]
        memcache.vm.network "private_network", ip: ENV["memcache_ip"]
        memcache.vm.provision "shell", path: "memcache_setup.sh"
    end

    config.vm.define "rmq02" do |rabbitmq|
        rabbitmq.vm.box = "ubuntu/focal64"
        rabbitmq.vm.hostname = ENV["rabbitmq_hostname"]
        rabbitmq.vm.network "private_network", ip: ENV["rabbitmq_ip"]
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
        tomcat.vm.hostname = ENV["tomcat_hostname"]
        tomcat.vm.network "private_network", ip: ENV["tomcat_ip"]
        config.vm.synced_folder "./#{ENV['application_directory']}", "/home/vagrant/#{ENV['application_directory']}", type: "rsync"
        tomcat.vm.provision "shell", path: "tomcat_setup.sh"
        if $? == 0
          tomcat.vm.provision "shell" do |shell|
       # Pass the variables to the provision script
         shell.args = [
          ENV['rabbitmqUsername'],
          ENV['rabbitmqPassword'],
          ENV['jdbcUsername'],
          ENV['jdbcPassword'],
          ENV['application_directory'],
      ]
         shell.path = "app_setup.sh"
      end
        else
          puts "Script 1 failed. Skipping script 2."
        end
    end

    config.vm.define "web02" do |nginx|
        nginx.vm.box = "ubuntu/focal64"
        nginx.vm.hostname = ENV["nginx_hostname"]
        nginx.vm.network "private_network", ip: ENV["nginx_ip"]
        nginx.vm.provision "shell" do |shell|
       # Pass the variables to the provision script
         shell.args = [
          ENV['tomcat_hostname'],
      ]
         shell.path = "nginx_setup.sh"
      end
    end
end 
