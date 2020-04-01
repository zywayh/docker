#!/bin/bash

# Master 节点初始化
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.16.4 --pod-network-cidr=10.0.0.0/16

# 按提示操作
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 添加 flannel 的网络
wget http://f.zyw.ink/flannel.yml
kubectl apply -f flannel.yml
