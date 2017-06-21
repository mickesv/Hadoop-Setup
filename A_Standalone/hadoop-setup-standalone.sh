#!/usr/bin/env bash

source ./hadoop-common.sh


# Check if run as root
if [ "$(id -u)" != "0" ]; then
    echo "Please use sudo for this script"
    exit 1
fi


# Copy files
cp ./hadoop-src-standalone/* $HADOOP_HOME/etc/hadoop
