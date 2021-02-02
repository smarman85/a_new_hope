#!/bin/bash

exec 1>/var/lib/cloud/stdout.txt
exec 2>/var/lib/cloud/stderr.txt

set -o xtrace
set -e

export DEBIAN_FRONTEND=noninteractive
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

sudo apt-get update -y

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get install docker-ce -y 

sudo usermod -aG docker ubuntu

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

#docker run -dith nginx --name nginx -p 80:80 nginx
#docker run -dtih hugo --name hugo -p 80:1313 smarman/portfolio:0.0.6
docker run -dtih gosite --name gosite -p 80:8080 smarman/gosite:0.0.7
