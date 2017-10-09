#
# Setup Stages, so that things are run in a correct order
# --------------------
stage { "setup":
  before => Stage['main'],
}

class { "hadoop":
  stage => "setup",
}

class { "sshsetup":
  stage => "setup",
}



#
# Install and configure Hadoop
# --------------------
class hadoop {
  $hadoop_home = "/usr/local/hadoop"
  $hadoop_ver = "2.8.1"
  $hadoop_dir = "/usr/local/hadoop-2.8.1"
  $path = "${path}:${hadoop_dir}/sbin:${hadoop_dir}/bin"
  $user = "vagrant"

  include java
    
  group { "group-vagrant":
    name => $user,
    ensure => "present",
  }
  
  user { "user-vagrant":
    name => $user,
    password => "hunter2",
    ensure => "present",
    groups => $user,
    home => "/home/${user}",
    managehome => true,
    require => Group["group-vagrant"];
  }    

  # exec { "debugging":
  #   command => "echo ${java::java_home} or ${java::default_java_home}",
  #   path => $path,
  #   loglevel => debug,
  #   logoutput => true,      
  #   require => [Class["java"], User["user-vagrant"]],
  # }    
  
  exec { "download_hadoop":
    command => "wget -O /home/${user}/hadoop.tar.gz http://www-eu.apache.org/dist/hadoop/common/hadoop-${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz",
    path => $path,
<<<<<<< HEAD:D_Docker_Cluster/modules/hadoop/manifests/init.pp
    unless => ["ls /usr/local/ | grep hadoop-2.8.1", "test -f /vagrant/hadoop.tar.gz"],
    require => Package["openjdk-7-jdk"], 
=======
    unless => ["ls /usr/local/ | grep hadoop-2.8.0", "test -f /home/${user}/hadoop.tar.gz"],        
    require => [Class["java"], User["user-vagrant"]],
>>>>>>> edb8e31f5c9bb28ab4e7d97ff2d49a5f86dabe53:D_Docker_Cluster/docker-image-base/modules/hadoop/manifests/init.pp
  }

  exec { "unpack_hadoop" :
    command => "tar -zxf /home/${user}/hadoop.tar.gz -C /usr/local/",
    path => $path,
    creates => "${hadoop_home}-${hadoop_ver}",
    require => Exec["download_hadoop"],    
  }
        
  file {
    "${hadoop_dir}/etc/hadoop/core-site.xml":
      source => "puppet:///modules/hadoop/core-site.xml",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  file {
    "${hadoop_dir}/etc/hadoop/mapred-site.xml":
      source => "puppet:///modules/hadoop/mapred-site.xml",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  file {
    "${hadoop_dir}/etc/hadoop/hdfs-site.xml":
      source => "puppet:///modules/hadoop/hdfs-site.xml",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],  
  }

  file {
    "${hadoop_dir}/etc/hadoop/hadoop-env.sh":
      source => "puppet:///modules/hadoop/hadoop-env.sh",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],  
  }

  file_line { "java-home":
    path => "${hadoop_dir}/etc/hadoop/hadoop-env.sh",
    line => "export JAVA_HOME=${java::default_java_home}",
    require => File["${hadoop_dir}/etc/hadoop/hadoop-env.sh"],
  }

  file {
    "${hadoop_dir}/etc/hadoop/yarn-env.sh":
      source => "puppet:///modules/hadoop/yarn-env.sh",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"], 
  }

  file {
    "${hadoop_dir}/etc/hadoop/yarn-site.xml":
      source => "puppet:///modules/hadoop/yarn-site.xml",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],
  }

  file {
    "/home/${user}/hadoop-common.sh":
      source => "puppet:///modules/hadoop/hadoop-common.sh",
      mode => "755",
      owner => $user,
      group => $user,
  }

  exec { "fixpaths":
    command => "echo 'source /home/${user}/hadoop-common.sh' >> /home/${user}/.profile",
    path => $path,    
    require => File["/home/${user}/hadoop-common.sh"],
  }

  file {
    "/hadoop-dfs-populate.sh":
      source => "puppet:///modules/hadoop/hadoop-dfs-populate.sh",
      mode => "755",
      owner => $user,
      group => $user,
  }

  file_line { "fix_comnmons":
    ensure => present,
    path => "/hadoop-dfs-populate.sh",
    line => "source /home/${user}/hadoop-common.sh",
    match => "^source",
  }

  # Fix all references to master so that they use the docker ip instead:
  # file_line {"master-core-site":
  #   ensure => present,
  #   path => "${hadoop_dir}/etc/hadoop/core-site.xml",
  #   line => "<value>hdfs://${::ipaddress}/</value>",
  #   match => "<value>hdfs://master/</value>",
  # }  
}



#
# Setup passphraseless ssh
# --------------------
class sshsetup {
  $user = "vagrant"

  file {
    "/home/${user}/.ssh":
      ensure => "directory",
      owner => "${user}",
      group => "${user}",
      mode => "750",
  }


  file {
    "/home/${user}/.ssh/id_rsa":
      source => "puppet:///modules/hadoop/id_rsa",
      ensure => present,
      mode => "600",
      owner => $user,
      group => $user,
      require => File["/home/${user}/.ssh"],
      
  }

  file {
    "/home/${user}/.ssh/id_rsa.pub":
      source => "puppet:///modules/hadoop/id_rsa.pub",
      ensure => present,
      mode => "644",
      owner => $user,
      group => $user,
      require => File["/home/${user}/.ssh"],
      
  }

  file {
    "/home/${user}/.ssh/config":
      owner => $user,
      group => $user,
      mode => "755",
      content => "StrictHostKeyChecking no",
      require => File["/home/${user}/.ssh/id_rsa.pub"],
      
  }

  ssh_authorized_key { "ssh_key":
    ensure => present,
    key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDdKWZVh9mJw9rkERaAxrczmyyVBHuvqbjxeyu4Uc6jfNbMnwK0X6tSA+csZRaMsAGowgBxU9L/YtCu3BTZCz0IhIS7mi6dO19n5O2YN+rljyiO/D9cSkB9JnPQYDqOCifP5FhxTQqyOvpPboutsaI0GcuHMG9eFWlGuB3kGvhemYGg3wDnyG03lXk31XfnPEKDDql/gC0Q5GWWmH6Ztrz2TNjXbRHb1Jt6Spo430Vrt1hHE4i/pB+HRVADVdcR3t4zdDZ6IhXLsF6x/OIVE3riARZ5Ife9qQuYwb2qn75huNFD8t7/TOPyENJ6lT4vy6UgLjJbBngQ+TcfW/hXXd91",
    type => "ssh-rsa",
    user => $user,
    require => File["/home/${user}/.ssh/id_rsa.pub"],  
  }
}



#
# Node: Master 
# --------------------

node "master" {
  $hadoop_home = "/usr/local/hadoop"
  $hadoop_ver = "2.8.1"
  $hadoop_dir = "/usr/local/hadoop-2.8.1"
  $path = "${path}:${hadoop_dir}/sbin:${hadoop_dir}/bin"
  $user = "vagrant"


  include hadoop
  include sshsetup
  include java
  
  file {
    "${hadoop_dir}/etc/hadoop/slaves":
      source => "puppet:///modules/hadoop/slaves",
      mode => "644",
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  file {
    "${hadoop_dir}/etc/hadoop/masters":
      source => "puppet:///modules/hadoop/masters",
      mode => "644",
      owner => root,
      group => root,
#      content => $::ipaddress,
      require => Exec["unpack_hadoop"],    
  }

  
  file {
    "/opt/hdfs":
      ensure => 'directory',
      owner => $user,
      group => $user,
  }
  
  # exec { "format_HDFS":
  #   environment => ["JAVA_HOME=${java::default_java_home}"],
  #   command => "hdfs namenode -format -force",
  #   path => $path,
  #   user => $user,
  #   creates => "/opt/hdfs/name",
  #   require => [File["/opt/hdfs/"],Exec["unpack_hadoop"],Class["java"]],
  # }
  
  # exec { "populate":
  #   command => "/home/${user}/hadoop-dfs-populate.sh",
  #   path => $path,
  #   require => [File["/home/${user}/hadoop-common.sh"],File["/home/${user}/hadoop-dfs-populate.sh"],Exec["format_HDFS"]],
  #   user => $user,
  #   loglevel => debug,
  #   logoutput => true,      
  # }      
}


#
# Nodes: Worker
# --------------------
# node /^worker\d+$/ {
node default {
  $hadoop_home = "/usr/local/hadoop"
  $hadoop_ver = "2.8.1"
  $hadoop_dir = "/usr/local/hadoop-2.8.1"
  $path = "${path}:${hadoop_dir}/sbin:${hadoop_dir}/bin"
  $user = "vagrant"

  include hadoop
  include sshsetup
  include java

  file {
    "/opt/hdfs":
      ensure => 'directory',
      owner => $user,
      group => $user,
  }
  
  notify {"Started Worker Node":}
}
