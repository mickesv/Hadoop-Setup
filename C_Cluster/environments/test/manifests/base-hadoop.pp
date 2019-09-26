include hadoop

group {"puppet":
  ensure => "present",
}

exec { 'apt-get update':
    command => 'apt-get update',
    path => $path,
}

package { "openjdk-8-jdk" :
   ensure => present,
  require => Exec['apt-get update']
}


#
# Node: Master 
# --------------------

node "master" {
  $hadoop_home = "/usr/local/hadoop"
  $hadoop_ver = "3.2.1"
  $hadoop_dir = "/usr/local/hadoop-${hadoop_ver}"
  $path = "${path}:${hadoop_dir}/sbin:${hadoop_dir}/bin"
  $jhome = "/usr/lib/jvm/java-8-openjdk-amd64"
  $user = "vagrant"


  include hadoop
  include sshsetup

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
    require => [File["/opt/hdfs/"],Exec["unpack_hadoop"],Package["openjdk-8-jdk"]],
  }
  
  exec { "start_dfs":
    command => "start-dfs.sh",
    path => $path,
    user => $user,
    require => [Exec["format_HDFS"],Package["openjdk-8-jdk"]],
    loglevel => debug,
    logoutput => true, 
  }

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
  $hadoop_ver = "3.2.1"
  $hadoop_dir = "/usr/local/hadoop-${hadoop_ver}"
  $path = "${path}:${hadoop_dir}/sbin:${hadoop_dir}/bin"
  $jhome = "/usr/lib/jvm/java-8-openjdk-amd64"
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
