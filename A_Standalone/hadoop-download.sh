#!/usr/bin/env bash

source hadoop-common.sh

# Check if run as root
if [ "$(id -u)" != "0" ] ; then
    echo "Please use sudo for this script"
    exit 1
fi

# Get and unzip Hadoop
# -----
if [ ! -d "$HADOOP_HOME" ] ; then
    sudo mkdir -p "$HADOOP_ROOT"
    pushd "$HADOOP_ROOT"
    wget http://apache.mirrors.spacedump.net/hadoop/common/$HADOOP_VER/$HADOOP_VER.tar.gz
    tar -zxf $HADOOP_VER.tar.gz
#    rm $HADOOP_VER.tar.gz
    mv $HADOOP_VER/* $HADOOP_ROOT    
    popd

    echo "source /vagrant/hadoop-common.sh" >> ~/.bashrc
else
    echo "Not installing $HADOOP_VER in $HADOOP_ROOT Already installed."
fi
