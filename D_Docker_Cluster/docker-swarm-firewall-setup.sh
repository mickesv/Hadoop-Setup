#!/usr/bin/env bash

# Source: https://docs.docker.com/engine/swarm/swarm-tutorial/#use-docker-for-mac-or-docker-for-windows

# Check if run as root
if [ "$(id -u)" != "0" ]; then
    echo "Please use sudo for this script"
    exit 1
fi


# Open up ports
ufw allow 2377
ufw allow 7946
ufw allow 4789
