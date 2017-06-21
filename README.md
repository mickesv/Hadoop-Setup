# Hadoop-Setup

Different configurations for setting up Hadoop (inside Vagrant)


**A_Standalone** A single node standalone setup. You need to manually run commands inside the VM:

```
cd /vagrant
./hadoop-download.sh
./hadoop-setup-standalone.sh
```

**B_Pseudo** Single node, running in Pseudo-distributed mode. Commands:

```
cd /vagrant
./hadoop-download.sh
./ssh-setup.sh
./hadoop-setup-pseudo-distributed.sh
./hadoop-dfs-populate.sh
```

**C_Cluster** Three worker nodes and one master. Provisioned with the help of Puppet. Just `vagrant up` and everything should be fine.

