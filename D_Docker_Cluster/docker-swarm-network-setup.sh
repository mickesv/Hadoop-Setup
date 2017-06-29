#!/usr/bin/env bash

# Make sure the firewall is aptly open, if it isn't already
source ./docker-swarm-firewall-setup.sh

# Get the IP
alias myip="ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

# Start the swarm
docker swarm init --advertise-addr `myip`


# create my overlay network
docker network create \
       --driver overlay \
       --subnet 10.0.5.0/24 \
       docker-hadoop-net


