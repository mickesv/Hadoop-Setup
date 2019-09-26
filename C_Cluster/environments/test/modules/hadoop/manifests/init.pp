#
# Install and configure Hadoop
# --------------------
class hadoop {
  $hadoop_home = "/usr/local/hadoop"
  $hadoop_ver = "3.2.1"
  $hadoop_dir = "/usr/local/hadoop-${hadoop_ver}"
  $path = "${path}:${hadoop_dir}/sbin:${hadoop_dir}/bin"
  $jhome = "/usr/lib/jvm/java-8-openjdk-amd64"
  $user = "vagrant"

  exec { "download_hadoop":
    command => "wget -O /vagrant/hadoop.tar.gz http://apache.mirrors.spacedump.net/hadoop/common/hadoop-${hadoop_ver}/hadoop-${hadoop_ver}.tar.gz",
    path => $path,
    unless => ["ls /usr/local/ | grep hadoop-${hadoop_ver}", "test -f /vagrant/hadoop.tar.gz"],
    require => Package["openjdk-8-jdk"], 
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
    "/home/${user}/hadoop-dfs-populate.sh":
      source => "puppet:///modules/hadoop/hadoop-dfs-populate.sh",
      mode => "755",
      owner => $user,
      group => $user,
  }
  
}



