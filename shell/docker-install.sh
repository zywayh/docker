#!/bin/bash

echo "docker linix contos7.* install init ----------------------------------------------------"

systemctl start docker
if [ $? -ne 0 ]; then 
  echo "安装阿里docker-----------------------------------------------------"
  curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
  echo "配置阿里docker镜像加速器-----------------------------------------------------------------"
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
  { "registry-mirrors": ["https://1u162jg6.mirror.aliyuncs.com"] }
EOF
  sudo systemctl daemon-reload
  sudo systemctl restart docker
fi

docker-compose -h
if [ $? -ne 0 ]; then 
  echo "安装docker-compose---------------------------------------------------------"
  if [ ! -f "/usr/local/bin/docker-compose" ]; then
    if [ ! -f "./docker-compose-Linux-x86_64" ]; then
      wget http://zyw-resource.oss-cn-beijing.aliyuncs.com/docker-compose-Linux-x86_64
      if [ $? -ne 0 ]; then 
        yum install wget -y
        wget http://zyw-resource.oss-cn-beijing.aliyuncs.com/docker-compose-Linux-x86_64
      fi
    fi
    mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  else
    if [ ! -x "/usr/local/bin/docker-compose" ]; then
      chmod +x /usr/local/bin/docker-compose
    fi
  fi
fi

chown -R 8983:root data/solr/mycores/

if [ -n "docker" ] && [ -n "docker-compose" ]; then
  rm -rf ./contos7.x-docker-install.sh
fi
