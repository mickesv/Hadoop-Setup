#!/usr/bin/env bash

# Check if run as root
if [ "$(id -u)" != "0" ]; then
    echo "Please use sudo for this script"
    exit 1
fi


echo "WARNING: This will delete your hadoop setup, including everything in your HDFS!"
read -p "Are you sure? " -n 1 -r REPLY
echo

source ./hadoop-common.sh

if [[ "$REPLY" =~ ^[Yy]$ ]] ; then
    # echo "Shutting down..."
    # ./stop.sh
    # echo "Removing /hdfs/* ..."
    # rm -rf /hdfs/*
    echo "Removing $HDP_HOME ..."
    rm -rf $HDP_HOME
else
    echo "Wise choice. Exiting."
fi
