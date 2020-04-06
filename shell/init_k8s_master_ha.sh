#!/bin/bash

# 安装keepalived
systemctl status keepalived.service
if [ $? -ne 0 ]; then
	echo "需要安装keepalived，请优先安装keepalived，否则无法构建master-ha"
else


if [ ! $# -gt 1 ];then
	echo "至少需要3个参数，请完善参数"
	echo "参数错误 <vip> <master1ip> [master2ip ....]，将多个master参数传递过来"
else

# 安装haproxy负载均衡
systemctl status haproxy.service
if [ $? -ne 0 ]; then
	yum install -y haproxy
	echo "systemctl restart haproxy && echo 启动haproxy >> $PWD/rc.log" >> rc.sh 
fi

rm -rf /etc/haproxy/haproxy.cfg
cat << EOF > /etc/haproxy/haproxy.cfg 
global
chroot /var/lib/haproxy
daemon
group haproxy
user haproxy
log 127.0.0.1:514 local0 warning
pidfile /var/lib/haproxy.pid
maxconn 20000
spread-checks 3
nbproc 8
defaults
log global
mode tcp
retries 3
option redispatch
listen https-apiserver
bind 0.0.0.0:8443 # 指定绑定的端口，ip都设置为0.0.0.0，我这里使用8443端口
mode tcp
balance roundrobin
timeout server 15s
timeout connect 15s
EOF

index=1
for i in $*        #在$*中遍历参数，此时每个参数都是独立的，会遍历$#次
do
  if [[ $index -ne 1 ]]  
	then  
		echo "server apiserver$index $i:6443 check port 6443 inter 5000 fall 5" >> /etc/haproxy/haproxy.cfg 
		echo "添加master服务器，ip：$i"
	fi 
    let index+=1
done

systemctl restart haproxy


vip=$1
# Master 节点初始化
kubeadm init \
--image-repository registry.aliyuncs.com/google_containers \
--kubernetes-version v1.16.4 \
--service-cidr=10.10.0.0/16 \
--pod-network-cidr=10.0.0.0/16 \
--control-plane-endpoint $vip:8443 \
--upload-certs

# 按提示操作
rm -rf $HOME/.kube
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 添加 flannel 的网络，如果文件不存在则下载
if [ ! -f "flannel.yml" ];then
wget http://f.zyw.ink/flannel.yml
fi
kubectl apply -f flannel.yml

fi

fi