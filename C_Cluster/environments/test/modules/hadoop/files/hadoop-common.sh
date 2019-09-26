#!/usr/bin/env bash

export HADOOP_VER=hadoop-3.2.1
export HADOOP_ROOT_ROOT=/usr/local
export HADOOP_ROOT=$HADOOP_ROOT_ROOT/$HADOOP_VER
export HADOOP_HOME=$HADOOP_ROOT

export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin 


# Set further environment variables (for Pseudo-mode)
export HADOOP_MAPRED_HOME=$HADOOP_HOME 
export HADOOP_COMMON_HOME=$HADOOP_HOME 
export HADOOP_HDFS_HOME=$HADOOP_HOME 
export HADOOP_YARN_HOME=$HADOOP_HOME 
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
export HADOOP_INSTALL=$HADOOP_HOME

export HADOOP_LOG_DIR=/tmp/hadoop-logs
