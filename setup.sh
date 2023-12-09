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
  sudo chmod u+x /tmp/get-docker.sh
  sudo sh /tmp/get-docker.sh
  echo "Docker installed successfully.. Enabling rootless mode"
  # enable docker cmd without root permission
  dockerd-rootless-setuptool.sh install
else
  echo "Docker is alread installed at `which docker`"
fi

# creating required directories
mkdir -p /home/pi/docker/{portainer,qbittorrent,downloads,h5ai,filebrowser}
touch /home/pi/docker/filebrowser/filebrowser.db
touch /home/pi/docker/filebrowser/settings.json
sudo chmod ugo+rwx /home/pi/docker/filebrowser/filebrowser.db /home/pi/docker/filebrowser/settings.json
echo -e '{\n  "port": 80,\n  "baseURL": "",\n  "address": "",\n  "log": "stdout",\n  "database": "/database/filebrowser.db",\n  "root": "/srv",\n  "noauth": true\n}' > /home/pi/docker/filebrowser/settings.json

# check if docker-compose is installed already
if [ `which docker-compose | wc -l` -eq 0 ]
then
  echo "docker-compose is not installed.. Installing it"
  sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-armv6 -o /usr/local/bin/docker-compose
  sudo chmod a+x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
else
  echo "docker-compose is already installed at `which docker-compose`"
fi

# running docker-compose.yml file
echo "Deploying containers using docker-compose"
sudo docker-compose up -d
