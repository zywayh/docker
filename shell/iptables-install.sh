echo "启用iptables防火墙-------------------------------------------------"
systemctl stop firewalld.service
systemctl disable firewalld.server
yum remove firewalld -y
