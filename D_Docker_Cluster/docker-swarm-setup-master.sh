#!/usr/bin/env bash

# Get the IP
alias myip="ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"


# Start the swarm
docker swarm init --advertise-addr `myip`

