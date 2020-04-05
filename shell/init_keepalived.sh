#!/bin/bash

if [ ! $# -gt 1 ];then
	echo "至少需要2个参数，请完善参数"
	echo "参数错误 <vip> <priority>"
else

vip=$1
priority=$2

uuid=$(cat /proc/sys/kernel/random/uuid)

# 安装keepalived
systemctl status keepalived.service
if [ $? -ne 0 ]; then
	yum install -y keepalived
fi

rm -rf /etc/keepalived/keepalived.conf
# 配置keepalived
cat << EOF > /etc/keepalived/keepalived.conf 
! Configuration File for keepalived

global_defs {
   router_id LVS_${state}_${uuid}
}

vrrp_instance VI_1 {
    state MASTER
    interface ens33
    virtual_router_id 51
    priority ${priority}
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        ${vip}
    }
}
EOF

systemctl enable keepalived.service && systemctl start keepalived.service

echo "keepalived安装完成，启动完成，配置开机启动完成，设置的VIP为${vip}"
echo "检查执行结果"
ip a | grep $vip

echo "nameserver 114.114.114.114" >>  /etc/resolv.conf 
echo "nameserver 8.8.8.8" >>  /etc/resolv.conf 
echo "nameserver 8.8.4.4" >>  /etc/resolv.conf 

fi





