include hadoop

group {"puppet":
  ensure => "present",
}

exec { 'apt-get update':
    command => 'apt-get update',
    path => $path,
}

package { "openjdk-7-jdk" :
   ensure => present,
  require => Exec['apt-get update']
}