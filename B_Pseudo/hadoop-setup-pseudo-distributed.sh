#!/usr/bin/env bash

source ./hadoop-common.sh

# Check if run as root
if [ "$(id -u)" == "0" ]; then
    echo "Please DO NOT use sudo for this script"
    exit 1
fi

# Copy files
sudo cp ./hadoop-src-pseudo/* $HADOOP_HOME/etc/hadoop

# Setup HDFS
hdfs namenode -format
start-dfs.sh
start-yarn.sh

