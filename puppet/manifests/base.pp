include apt

group { 'puppet':
	ensure => present,
}

exec { 'apt-get update': 
	command => '/usr/bin/apt-get update',
}

package { 'nginx': 
	ensure => present,
	require => Exec['apt-get update'],
}

/*
package { 'php5-fpm':
	ensure => present,
	require => Exec['apt-get update'],
}
*/

service { 'nginx':
	ensure => running,
	require => Package['nginx'],
}

/*
service { 'php5-fpm':
	ensure => running,
	require => Package['php5-fpm'],
}
*/

file { 'vagrant-nginx':
	path => '/etc/nginx/sites-available/default',
	ensure => file,
    replace => true,
	require => Package['nginx'],
	source => 'puppet:///modules/nginx/default',
    notify => Service['nginx'],
}

file { 'vagrant-nginx-enable':
	path => '/etc/nginx/sites-enabled/vagrant',
	target => '/etc/nginx/sites-available/vagrant',
	ensure => link,
	notify => Service['nginx'],
	require => [
		File['vagrant-nginx']
	],
}

class { '::nodejs':
  manage_package_repo       => false,
  nodejs_dev_package_ensure => 'present',
  npm_package_ensure        => 'present',
}

#Symlink 
file { '/usr/bin/node':
  ensure => 'link',
  target => "/usr/bin/nodejs",
  require => [
		Class['nodejs'],
	],
}


#install_options required for windows machines
nodejs::npm { 'serverapp':
require => [
		Class['nodejs'],
	],

  ensure           => 'present',
  target  => '/var/www/',  
  use_package_json => true,
  install_options => ['--no-bin-links'], 
}

nodejs::npm { 'forever from the npm registry':
require => [
		Class['nodejs'],
	],
	ensure  => 'present',
	package => 'forever',
	target  => '/usr/local/lib/',  
}


apt::source { 'mariadb':
  location => 'http://sgp1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu',
  release  => $::lsbdistcodename,
  repos    => 'main',
  key      => {
    id     => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
    server => 'hkp://keyserver.ubuntu.com:80',
  },
  include => {
    src   => false,
    deb   => true,
  },
}

class {'::mysql::server':
  package_name     => 'mariadb-server',
  package_ensure   => '10.1.29+maria-1~xenial',
  service_name     => 'mysql',
  root_password    => 'SomePasswordHere',
  override_options => {
    mysqld => {
      'log-error' => '/var/log/mysql/mariadb.log',
      'pid-file'  => '/var/run/mysqld/mysqld.pid',
    },
    mysqld_safe => {
      'log-error' => '/var/log/mysql/mariadb.log',
    },
    restart => true,
  }
}

mysql::db { 'database':
  user     => 'vagrant',
  password => 'vagrant',
  host     => 'localhost',
  grant    => ['SELECT', 'UPDATE'],
}
