#!/usr/bin/env bash

docker build -t="msv/docker-hadoop-base"

cd docker-master
docker build -t="msv/docker-hadoop-master"
