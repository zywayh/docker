#!/bin/bash

docker-compose -h
if [ $? -ne 0 ]; then 
  echo "安装docker-compose---------------------------------------------------------"
  curl -L https://get.daocloud.io/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi
