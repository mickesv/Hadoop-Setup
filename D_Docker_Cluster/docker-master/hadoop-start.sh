#!/usr/bin/env bash

trap "echo TRAPed signal" HUP INT QUIT TERM

source /modules/hadoop/files/hadoop-common.sh

start-dfs.sh
start-yarn.sh

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

stop-yarn.sh
stop-dfs.sh

echo "exited $0"

