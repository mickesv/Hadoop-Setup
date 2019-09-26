#!/usr/bin/env sh

for i in `seq 1 10`; do
 hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar wordcount input $1

 hdfs dfs -cat $1/* | head -30

 hdfs dfs -rm -r -f $1
done
