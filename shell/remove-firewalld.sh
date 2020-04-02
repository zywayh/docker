echo "卸载firewalld防火墙-------------------------------------------------"
systemctl stop firewalld.service
systemctl disable firewalld.server
yum remove firewalld -y
