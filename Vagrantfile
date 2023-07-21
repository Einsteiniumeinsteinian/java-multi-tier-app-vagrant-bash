Vagrant.configure("2") do |config|

    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true

    config.vm.define "database_server" do |mariadb|
        mariadb.vm.box = "spox/ubuntu-arm"
        mariadb.vm.box_version = "1.0.0"
        mariadb.vm.hostname = "mariadb"
        mariadb.vm.network "private_network", ip: "192.168.33.10"
        mariadb.vm.provision "shell", path: "mariadb_setup.sh"
    end

    config.vm.define "cache_server" do |memcache|
        memcache.vm.box = "spox/ubuntu-arm"
        memcache.vm.box_version = "1.0.0"
        memcache.vm.hostname = "memcache"
        memcache.vm.network "private_network", ip: "192.168.33.27"
        memcache.vm.provision "shell", path: "memcache_setup.sh"
    end

    config.vm.define "messaging" do |rabbitmq|
        rabbitmq.vm.box = "spox/ubuntu-arm"
        rabbitmq.vm.box_version = "1.0.0"
        rabbitmq.vm.hostname = "rabbitmq"
        rabbitmq.vm.network "private_network", ip: "192.168.33.12"
        rabbitmq.vm.provision "shell", path: "rabbitmq_setup.sh"
        
    end

    config.vm.define "web_server" do |tomcat|
        tomcat.vm.box = "spox/ubuntu-arm"
        tomcat.vm.box_version = "1.0.0"
        tomcat.vm.hostname = "tomcat"
        tomcat.vm.network "private_network", type: "dhcp"
        tomcat.vm.provision "shell", path: "tomcat_setup.sh"
        tomcat.vm.provider "vmware_desktop" do |vb|
            vb.memory = "1024"
            vb.gui = true
            vb.allowlist_verified = true
           end
    end

    config.vm.define "load_balancer" do |nginx|
        nginx.vm.box = "spox/ubuntu-arm"
        nginx.vm.box_version = "1.0.0"
        nginx.vm.hostname = "nginx"
        nginx.vm.network "private_network", ip: "192.168.33.17"
        nginx.vm.network "forwarded_port", guest: 80, host: 8080
        nginx.vm.provision "shell", path: "nginx_setup.sh"
    end
end 