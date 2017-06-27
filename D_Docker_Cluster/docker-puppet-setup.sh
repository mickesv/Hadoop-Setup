#!/usr/bin/env bash

docker build -t "msv/docker-hadoop-base" .
docker build -t "msv/docker-hadoop-master" docker-master/
