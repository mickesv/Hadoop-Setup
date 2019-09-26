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



