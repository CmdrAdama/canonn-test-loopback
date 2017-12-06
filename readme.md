
Requirements
-----

-	[VirtualBox](https://www.virtualbox.org/wiki/Downloads)
-	[Vagrant](https://www.vagrantup.com)

Setup
-----

-	Clone this repo
-	Run `vagrant up`
-   Note: `vagrant provision` may need to be run a few times after the initial startup to allow complete provisioning of npm and maria.  
-	Navigate to the server by going to: http://localhost:8888 



Usage
-----

Some basic information on interacting with the vagrant box:

### Ports

-	nginx **8080** 
-	mariadb **8889**
	-	User: *vagrant*
	-	Password: *vagrant*
	-	Database: *database*


### Vagrant Basics

Full documents can be found [here](https://www.vagrantup.com/docs/index.html)

Sample usage:

-	`vagrant up` starts the VM and provision it (if it hasn't been done yet)
-	`vagrant suspend` put the VM to sleep 
-   `vagrant resume` wake the VM
-	`vagrant halt` Shutdown the VM
-	`vagrant ssh` remote to the VM.  Git's ssh client works well on windows
-	`vagrant destroy` Delete the VM (source files will be retained)

Attribution
-----
Derived from [LEMN](https://github.com/tbremer/LEMN)
Puppet provision installation modified from https://gist.github.com/davidtsadler/786620cad83a544a553cdc206334b423