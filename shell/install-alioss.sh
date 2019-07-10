#!/bin/sh
if [ $# -ge 3 ];then
    local_path=/ossfs/$1
    ossfs -h
    if [ $? -ne 0 ]; then 
        echo "安装wget工具"
        yum install wget -y
        
        echo "安装mailcap，使生成/etc/mime.types，上传文件时以区分不同文件的不同请求头"
        # https://help.aliyun.com/document_detail/32197.html?spm=a2c4g.11186623.6.724.3bff6ea3uoTFvc#title-h54-e3n-a2v
        # ossfs通过查询/etc/mime.types中的内容来确定文件的Content-Type，请检查这个文件是否存在，如果不存在，则需要添加：
        # 对于Ubuntu可以通过sudo apt-get install mime-support来添加。
        # 对于CentOS可以通过sudo yum install mailcap来添加。
        # 也可以手动添加，每种格式一行，每行格式为：application/javascript js。
        sudo yum install mailcap
        
        #文档地址 https://help.aliyun.com/document_detail/32196.html?spm=a2c4g.11174283.3.8.74c37da29O7Tso
        echo "下载ossfs镜像文件"
        wget http://gosspublic.alicdn.com/ossfs/ossfs_1.80.5_centos7.0_x86_64.rpm
        
        echo "安装ossfs镜像文件"
        sudo yum localinstall ossfs_1.80.5_centos7.0_x86_64.rpm
    fi

    echo "设置oss账号信息"
    #echo <my-bucket>:<my-access-key-id>:<my-access-key-secret> /etc/passwd-ossfs
    echo $1:$2:$3 >> /etc/passwd-ossfs
    chmod 640 /etc/passwd-ossfs
    
    echo "映射oss目录"
    
    if [ ! -d "$local_path" ];then
        mkdir -p $local_path
    fi
    #ossfs <my-bucket> <my-mount-point> -ourl=<my-oss-endpoint>
    ossfs $1 $local_path -ourl=http://oss-cn-beijing-internal.aliyuncs.com

    #配置开机启动 automount
    #https://github.com/aliyun/ossfs/blob/master/scripts/automount.template?spm=a2c4g.11186623.2.34.4a792e08BfLZFm&file=automount.template
    #将命令配置到开机脚本中
    echo "ossfs $1 $local_path -ourl=http://oss-cn-beijing-internal.aliyuncs.com -oallow_other" >> ./rc.sh
    
else
    echo "参数错误 <bucket> <key> <secret> "
fi






