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

sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get install -y docker-ce \
    jq \
    awscli

sudo usermod -aG docker ubuntu

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

aws ssm get-parameter --name /app/homelab/env --region us-west-2 | jq -r '.Parameter.Value' > /home/ubuntu/.env

# docker run -dith gosite --env-file /home/ubuntu/.env --name gosite -p 80:8080 smarman/go-site-gin:26a560c0e99fd4118820e94a9e1549f1ddb78294-arm64 ./goSiteGin
docker run -dith gosite --env-file /home/ubuntu/.env --name gosite -p 80:8080 smarman/go-site-gin:191e5cff68486b22a2bedcd5a4b8dc965e16b839-arm64 ./goSiteGin
