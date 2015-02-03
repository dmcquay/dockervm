#!/usr/bin/env bash

apt-get update
apt-get install -y docker.io mysql-client-core-5.6 pv

# install fig
curl -L https://github.com/docker/fig/releases/download/1.0.1/fig-`uname -s`-`uname -m` > /usr/local/bin/fig; chmod +x /usr/local/bin/fig
