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
  $jhome = "/usr/lib/jvm/java-7-openjdk-amd64"
  $user = "vagrant"

  exec { "download_hadoop":
    command => "wget -O /vagrant/hadoop.tar.gz http://www-eu.apache.org/dist/hadoop/common/hadoop-${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz",
    path => $path,
    unless => ["ls /usr/local/ | grep hadoop-2.8.1", "test -f /vagrant/hadoop.tar.gz"],
    require => Package["openjdk-7-jdk"], 
  }

  exec { "unpack_hadoop" :
    command => "tar -zxf /vagrant/hadoop.tar.gz -C /usr/local/",
    path => $path,
    creates => "${hadoop_home}-${hadoop_ver}",
    require => Exec["download_hadoop"],    
  }
        
  file {
    "${hadoop_dir}/etc/hadoop/core-site.xml":
      source => "puppet:///modules/hadoop/core-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  file {
    "${hadoop_dir}/etc/hadoop/mapred-site.xml":
      source => "puppet:///modules/hadoop/mapred-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  file {
    "${hadoop_dir}/etc/hadoop/hdfs-site.xml":
      source => "puppet:///modules/hadoop/hdfs-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],  
  }

  file {
    "${hadoop_dir}/etc/hadoop/hadoop-env.sh":
      source => "puppet:///modules/hadoop/hadoop-env.sh",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],  
  }

  file {
    "${hadoop_dir}/etc/hadoop/yarn-env.sh":
      source => "puppet:///modules/hadoop/yarn-env.sh",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"], 
  }

  file {
    "${hadoop_dir}/etc/hadoop/yarn-site.xml":
      source => "puppet:///modules/hadoop/yarn-site.xml",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],
  }

  file {
    "/home/${user}/hadoop-common.sh":
      source => "puppet:///modules/hadoop/hadoop-common.sh",
      mode => 755,
      owner => $user,
      group => $user,
  }

  exec { "fixpaths":
    command => "echo 'source /home/${user}/hadoop-common.sh' >> /home/${user}/.profile",
    path => $path,    
    require => File["/home/${user}/hadoop-common.sh"],
  }

  file {
    "/home/${user}/hadoop-dfs-populate.sh":
      source => "puppet:///modules/hadoop/hadoop-dfs-populate.sh",
      mode => 755,
      owner => $user,
      group => $user,
  }
  
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
      mode => 750,
  }


  file {
    "/home/${user}/.ssh/id_rsa":
      source => "puppet:///modules/hadoop/id_rsa",
      ensure => present,
      mode => 600,
      owner => $user,
      group => $user,
      require => File["/home/${user}/.ssh"],
      
  }

  file {
    "/home/${user}/.ssh/id_rsa.pub":
      source => "puppet:///modules/hadoop/id_rsa.pub",
      ensure => present,
      mode => 644,
      owner => $user,
      group => $user,
      require => File["/home/${user}/.ssh"],
      
  }

  file {
    "/home/${user}/.ssh/config":
      owner => $user,
      group => $user,
      mode => 755,
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
  $jhome = "/usr/lib/jvm/java-7-openjdk-amd64"
  $user = "vagrant"


  include hadoop
  include sshsetup

  file {
    "${hadoop_dir}/etc/hadoop/slaves":
      source => "puppet:///modules/hadoop/slaves",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  file {
    "${hadoop_dir}/etc/hadoop/masters":
      source => "puppet:///modules/hadoop/masters",
      mode => 644,
      owner => root,
      group => root,
      require => Exec["unpack_hadoop"],    
  }

  
  file {
    "/opt/hdfs":
      ensure => 'directory',
      owner => $user,
      group => $user,
  }
  
  exec { "format_HDFS":
    environment => ["JAVA_HOME=${jhome}"],
    command => "hdfs namenode -format -force",
    path => $path,
    user => $user,
    creates => "/opt/hdfs/name",
    require => [File["/opt/hdfs/"],Exec["unpack_hadoop"],Package["openjdk-7-jdk"]],
  }
  
  # exec { "start_dfs":
  #   command => "start-dfs.sh",
  #   path => $path,
  #   user => $user,
  #   require => [Exec["format_HDFS"],Package["openjdk-7-jdk"]],
  #   loglevel => debug,
  #   logoutput => true, 
  # }

  # exec { "start_yarn":
  #   command => "start-yarn.sh",
  #   path => $path,
  #   user => $user, 
  #   require => [Exec["format_HDFS"],Package["openjdk-7-jdk"]],
  #   loglevel => debug,
  #   logoutput => true,  
  # }

  exec { "populate":
    command => "/home/${user}/hadoop-dfs-populate.sh",
    path => $path,
    require => [File["/home/${user}/hadoop-common.sh"],File["/home/${user}/hadoop-dfs-populate.sh"],Exec["start_dfs"]],
    user => $user,
    loglevel => debug,
    logoutput => true,      
  }      
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
  $jhome = "/usr/lib/jvm/java-7-openjdk-amd64"
  $user = "vagrant"

  include hadoop
  include sshsetup

  file {
    "/opt/hdfs":
      ensure => 'directory',
      owner => $user,
      group => $user,
  }
  
  notify {"Started Worker Node":}
}
