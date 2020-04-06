#!/bin/bash

# 环境
# docker: 19.03.5
# kube: 1.16.4


echo "初始化安装k8s，本次安装使用1.16.4版本，对应master-ha固定写死的版本。如需尝试其他版本请修改对应的脚本"

# 关闭 selinux
setenforce 0
mv /etc/sysconfig/selinux /etc/sysconfig/selinux.bak
cat <<EOF > /etc/sysconfig/selinux
SELINUX=disabled
SELINUXTYPE=targeted
EOF

# 关闭 swap
swapoff -a
sed -i.bak '/swap/s/^/#/' /etc/fstab

# 配置 ip_forward 转发
echo "1" > /proc/sys/net/ipv4/ip_forward

# 添加br_netfilter，系统重启后失效，需要配置开机启动
modprobe br_netfilter
chmod +x /etc/rc.d/rc.local
echo "modprobe br_netfilter" >> /etc/rc.d/rc.local

# 更新 yum 源
cd /etc/yum.repos.d
rm -rf *
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo

# 刷新 yum 缓存
yum clean all && yum makecache fast

# 配置 k8s 源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF

# k8s 运行要求 docker 的--cgroup-driver=systemd
cat <<EOF > /etc/docker/daemon.json
{
	"registry-mirrors": ["https://thu8zyqr.mirror.aliyuncs.com"], 
	"exec-opts": ["native.cgroupdriver=systemd"]
} 
EOF

# 添加 kubectl 上下文到环境中
cd
echo "source <(kubectl completion bash)" >> .bash_profile
source .bash_profile

# k8s 网络一般使用 flannel，该网络需要设置内核参数 bridge-nf-call-iptables=1 添加参数配置文件
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p /etc/sysctl.d/k8s.conf

# 安装 k8s 组件
yum install -y kubelet-1.16.4 kubeadm-1.16.4 kubectl-1.16.4

# 配置kubelet并设置开机启动
# systemctl enable kubelet && systemctl start kubelet
# 配置docker开机启动
echo "systemctl restart kubelet && echo $(date "+%Y-%m-%d %H:%M:%S") -> 开机启动kubelet >> rc.log" >> rc.sh 


echo "k8s基础环境搭建完毕，如需启动master，请使用k8s_init_master应脚本安装。"
echo "截止当前位置，k8s work节点完成，通过kubeadm join加入master节点"