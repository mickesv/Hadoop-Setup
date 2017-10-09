#!/usr/bin/env bash

case $1 in
    build)
	# Build my images
	docker build -t msv/docker-hadoop-base:latest docker-image-base/
	docker build -t msv/docker-hadoop-master:latest docker-image-master/
	docker build -t msv/docker-hadoop-worker:latest docker-image-worker/
	;;
    publish)
	echo "This only has meaning if you also go through the trouble of creating a https certificate. Exiting".
	exit 0
	
	
	# Start a local registry and publish the master and the worker	
	docker run -d -p 5000:5000 --name registry registry:2
	docker tag msv/docker-hadoop-master localhost:5000/msv/docker-hadoop-master
	docker tag msv/docker-hadoop-worker localhost:5000/msv/docker-hadoop-worker
	docker push localhost:5000/msv/docker-hadoop-master
	docker push localhost:5000/msv/docker-hadoop-worker

	# Open up the firewall, allow nodes to pull the images, then close the firewall
	sudo uwf allow 5000

	# Get the IP
	alias myip="ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"


	echo "Please run the following commands on your nodes, then press enter here"
	echo docker pull `myip`:5000/msv/docker-hadoop-master
	echo docker pull `myip`:5000/msv/docker-hadoop-worker	
	read
	sudo ufw deny 5000
	;;
    pull)
	echo "This only has meaning if you also go through the trouble of creating a https certificate. Exiting".
	exit 0
	
	if [ -z ${2+x} ]; then
	    echo "Missing address of registry host computer. Exiting"
	    exit 1
	fi
	     
	docker pull $2:5000/msv/docker-hadoop-master
	docker pull $2:5000/msv/docker-hadoop-worker	
	;;
    *)
	echo $"Usage: $0 {build|publish|pull}"
	exit 1	
esac
