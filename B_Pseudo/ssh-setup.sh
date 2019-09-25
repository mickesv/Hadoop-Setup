#!/usr/bin/env bash

# Check if run as root
if [ "$(id -u)" == "0" ]; then
    echo "Please DO NOT use sudo for this script"
    exit 1
fi

# Setup passphraseless ssh
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
