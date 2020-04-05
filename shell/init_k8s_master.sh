#!/bin/bash

echo "初始化前，必须将自己的ssh key公钥注册到自己的authorized_keys上"
echo "生成公钥的命令：ssh-keygen -t rsa -C '邮箱'"
echo "拷贝公钥到authorized_keys：echo '$(cat ~/.ssh/id_rsa.pub) >> authorized_keys'"

# Master 节点初始化
kubeadm init  \
--image-repository registry.aliyuncs.com/google_containers \
--kubernetes-version v1.16.4 \
--pod-network-cidr=10.0.0.0/16

# 按提示操作
rm -rf $HOME/.kube
mkdir -p $HOME/.kube
sudo cp -rf -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 添加 flannel 的网络
if [ ! -f "flannel.yml" ];then
wget http://f.zyw.ink/flannel.yml
fi
kubectl apply -f flannel.yml
