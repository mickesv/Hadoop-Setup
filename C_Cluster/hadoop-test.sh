#!/usr/bin/env sh

hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar wordcount input output

hdfs dfs -cat output/* | head -30

hdfs dfs -rm -r -f output
