#!/usr/bin/env bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y lxc-docker mysql-client-core-5.6 pv ntp

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# symlink fig for convenience
ln -s /usr/local/bin/docker-compose /usr/local/bin/fig

# install docker-volumes to help us prune orphaned volumes
docker build -t docker-volumes https://github.com/cpuguy83/docker-volumes.git
docker run --name docker-volumes docker-volumes
docker cp docker-volumes:/docker-volumes /usr/local/bin/
docker rm docker-volumes
docker rmi docker-volumes golang:1.3-cross

# prune orphaned docker images and voumes hourly
HOURLY_CRON=/etc/cron.hourly/dockervm
echo '#!/bin/bash' > $HOURLY_CRON
echo 'for v in $(docker-volumes list -q); do docker-volumes rm $v; done;' >> $HOURLY_CRON
echo 'docker rmi $(docker images -q --filter "dangling=true")' >> $HOURLY_CRON
chmod +x $HOURLY_CRON
