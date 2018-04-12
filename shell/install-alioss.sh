#!/bin/sh

ossfs_rpm_path=http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/32196/cn_zh/1507811577850/ossfs_1.80.3_centos7.0_x86_64.rpm?spm=5176.doc32196.2.6.Xj3xRk&file=ossfs_1.80.3_centos7.0_x86_64.rpm

wget $ossfs_rpm_path
if [ $? -ne 0 ]; then
    yum install wget -y
    wget $ossfs_rpm_path
fi

sudo yum localinstall ossfs_1.80.3_centos7.0_x86_64.rpm

echo <my-bucket>:<my-access-key-id>:<my-access-key-secret> /etc/passwd-ossfs
chmod 640 /etc/passwd-ossfs

ossfs my-bucket my-mount-point -ourl=my-oss-endpoint


