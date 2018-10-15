#!/bin/sh

if [ $# -ge 3 ];then
    echo "安装wget工具"
    yum install wget -y
    
    echo "下载ossfs镜像文件"
    wget ossfs_rpm_path=http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/32196/cn_zh/1507811577850/ossfs_1.80.5_centos7.0_x86_64.rpm
    
    echo "安装ossfs镜像文件"
    sudo yum localinstall ossfs_1.80.5_centos7.0_x86_64.rpm

    echo "设置oss账号信息"
    #echo <my-bucket>:<my-access-key-id>:<my-access-key-secret> /etc/passwd-ossfs
    echo $1:$2:$3 /etc/passwd-ossfs
    chmod 640 /etc/passwd-ossfs
    
    echo "映射oss目录"
    mkdir ossfs
    #ossfs <my-bucket> <my-mount-point> -ourl=<my-oss-endpoint>
    ossfs $1 /ossfs -ourl=http://oss-cn-beijing.aliyuncs.com
else
    echo "参数错误 <bucket> <key> <secret> "
fi






