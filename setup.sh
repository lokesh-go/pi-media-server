#!/bin/bash
set -e

# install required packages
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y

# check if docker is installed already
if [ `which docker | wc -l` -eq 0 ]
then
  echo "Docker is not installed.. Installing Docker"
  # install docker
  sudo curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  echo "Docker installed successfully.. Enabling rootless mode"
  # enable docker cmd without root permission
  dockerd-rootless-setuptool.sh install
else
  echo "Docker is alread installed at `which docker`"
fi
