#!/bin/bash

# install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# enable docker cmd without root permission
dockerd-rootless-setuptool.sh install


