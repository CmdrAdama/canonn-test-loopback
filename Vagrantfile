# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    ## Box
        config.vm.box = "bento/ubuntu-16.04"

        config.vm.provider "virtualbox" do |v|
            v.name = "Loopback"
            v.memory = 512
            v.cpus = 2
        end

    ## Folders
        config.vm.synced_folder "www", "/var/www/"
        config.vm.synced_folder "bash_scripts", "/home/vagrant/bash_scripts"
        config.vm.synced_folder "nginx/global", "/etc/nginx/global"
        config.vm.synced_folder "nginx/sites-available", "/etc/nginx/sites-available"

    ## Networking

        config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true # nginx port
        
        config.vm.network :forwarded_port, guest: 3306, host: 8889, auto_correct: true # mariadb port

        #config.vm.network "forwarded_port", guest: 3000, host: 8888, auto_correct: true # nginx port

    ## Provisioning
        #From https://gist.github.com/davidtsadler/786620cad83a544a553cdc206334b423
        config.vm.provision :shell, :path   => "bash_scripts/puppify.sh" #Install puppet

        config.vm.provision :puppet do |puppet|
            puppet.manifests_path = "puppet/manifests"
            puppet.manifest_file  = "base.pp"
            puppet.module_path = "puppet/modules"
        end

        ##config.vm.provision :shell, :path   => "puppet/scripts/enable_remote_mysql_access.sh"
        config.vm.provision :shell, :path   => "bash_scripts/start_nginx_and_node_servers.sh", run: 'always'

end

