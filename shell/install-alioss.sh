#!/bin/sh

if [ $# -ge 3 ];then
    echo "安装wget工具"
    yum install wget -y
    
    #文档地址 https://help.aliyun.com/document_detail/32196.html?spm=a2c4g.11174283.3.8.74c37da29O7Tso
    echo "下载ossfs镜像文件"
    wget http://gosspublic.alicdn.com/ossfs/ossfs_1.80.5_centos7.0_x86_64.rpm?spm=a2c4g.11186623.2.13.1a4673583Mej1u&file=ossfs_1.80.5_centos7.0_x86_64.rpm
    
    echo "安装ossfs镜像文件"
    sudo yum localinstall ossfs_1.80.5_centos7.0_x86_64.rpm

    echo "设置oss账号信息"
    #echo <my-bucket>:<my-access-key-id>:<my-access-key-secret> /etc/passwd-ossfs
    echo $1:$2:$3 > /etc/passwd-ossfs
    chmod 640 /etc/passwd-ossfs
    
    echo "映射oss目录"
    
if [ ! -d "/ossfs/" ];then
    mkdir /ossfs
fi
    #ossfs <my-bucket> <my-mount-point> -ourl=<my-oss-endpoint>
    ossfs $1 /ossfs -ourl=http://oss-cn-beijing.aliyuncs.com
else
    echo "参数错误 <bucket> <key> <secret> "
fi






