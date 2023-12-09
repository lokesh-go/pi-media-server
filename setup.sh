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
chmod 777 /home/pi/docker/filebrowser/filebrowser.db /home/pi/docker/filebrowser/settings.json
echo -e '{\n  "port": 80,\n  "baseURL": "",\n  "address": "",\n  "log": "stdout",\n  "database": "/database/filebrowser.db",\n  "root": "/srv",\n  "noauth": true\n}' > /home/pi/docker/filebrowser/settings.json

# running docker-compose.yml file
echo "Deploying containers"
UID="$(id -u)" GID="$(id -g)" docker-compose up -d
