#!/usr/bin/env bash

# Open up firewall
# ----------
# sudo ufw allow 50070
# sudo ufw allow 8020
# sudo ufw allow 8030
# sudo ufw allow 8031
# sudo ufw allow 8032
# sudo ufw allow 8088
# sudo ufw allow 9000

# Run the actual containers
# ----------

# docker run -t -i --rm --cap-add=NET_ADMIN --network=host --name master msv/docker-hadoop-master
# docker run -t -i -P --rm --cap-add=NET_ADMIN --name master msv/docker-hadoop-master

# Swarmy instead
docker service create --network docker-hadoop-net --name worker0 msv/docker-hadoop-worker
docker service create --network docker-hadoop-net --name worker1 msv/docker-hadoop-worker
docker service create --network docker-hadoop-net --name worker2 msv/docker-hadoop-worker

# give them time to get up and running
sleep 5
docker service create --network docker-hadoop-net --name master msv/docker-hadoop-master

# Throw in a monitor as well
docker service create --network docker-hadoop-net --name monitor busybox read


# Close the firewall again
# ----------
# sudo ufw deny 50070 # namenode http address
# sudo ufw deny 8020  # namenode fs default
# sudo ufw deny 8030  # resourcemanager scheduler
# sudo ufw deny 8031  # resourcemanager tracker
# sudo ufw deny 8032  # resourcemanager address
# sudo ufw deny 8088  # resourcemanager http address
# sudo ufw deny 9000  # FS.defaultFS
# sudo ufw deny 50010 # datanode address
# sudo ufw deny 50020 # datanode ipc address
# sudo ufw deny 50075 # datanode http address
# sudo ufw deny 8040  # nodemanager localizer
# sudo ufw deny 8041  # nodemanager address
# sudo ufw deny 8042  # nodemanager http address
# sudo ufw deny 1004  # datanode.address

# sudo ufw deny 20000:49999/tcp
# sudo ufw deny 20000:49999/udp
# Hopefully, this is the range in which nodemanager assigns its containers addresses.
