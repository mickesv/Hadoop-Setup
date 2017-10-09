#!/usr/bin/env bash

trap "echo TRAPed signal" HUP INT QUIT TERM

source /modules/hadoop/files/hadoop-common.sh

if [ -e "/opt/hdfs/namenode" ]
then
    echo "INFO: Namenode seems to already be formatted. Skiping formatting."
else
    echo "INFO: Formatting HDFS... There must be a better way to do this, but for now..."
    hdfs namenode -format -force

    echo "INFO: Populating..."
    /hadoop-dfs-populate.sh
fi

echo "INFO: Starting HDFS and YARN..."

start-dfs.sh
start-yarn.sh

echo "WAIT: [hit enter key to exit] or run 'docker stop <container>'"
read

echo "INFO: Stopping HDFS and YARN..."

stop-yarn.sh
stop-dfs.sh

echo "INFO: exited $0"

