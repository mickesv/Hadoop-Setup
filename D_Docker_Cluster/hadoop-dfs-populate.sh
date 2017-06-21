#!/usr/bin/env bash

source ./hadoop-common.sh


# Required to run MapReduce Jobs (output ends up here)
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/vagrant  # Best guess is that <username> should be "vagrant" for now.

# Create a place for input files and copy them there from your local filesystem
hdfs dfs -mkdir input
hdfs dfs -put $HADOOP_HOME/*.txt input
