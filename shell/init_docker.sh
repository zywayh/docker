#!/bin/bash
 
echo "docker linix contos7.* install init ----------------------------------------------------"
systemctl start docker
if [ $? -ne 0 ]; then 
  echo "安装阿里docker-----------------------------------------------------"
  echo "阿里docker https://cr.console.aliyun.com"
  echo "阿里docker安装文档 https://yq.aliyun.com/articles/110806?spm=5176.8351553.0.0.be7e1991bkjlok"
  # 安装必要的一些系统工具
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  # 添加软件源信息
  sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  # 更新并安装 Docker-CE
  sudo yum makecache fast
  sudo yum -y install docker-ce
  # 开启Docker服务
  sudo systemctl restart docker

  # 注意：其他注意事项在下面的注释中
  # 官方软件源默认启用了最新的软件，您可以通过编辑软件源的方式获取各个版本的软件包。例如官方并没有将测试版本的软件源置为可用，你可以通过以下方式开启。同理可以开启各种测试版本等。
  # vim /etc/yum.repos.d/docker-ce.repo
  #   将 [docker-ce-test] 下方的 enabled=0 修改为 enabled=1
  #
  # 安装指定版本的Docker-CE:
  # Step 1: 查找Docker-CE的版本:
  # yum list docker-ce.x86_64 --showduplicates | sort -r
  #   Loading mirror speeds from cached hostfile
  #   Loaded plugins: branch, fastestmirror, langpacks
  #   docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable
  #   docker-ce.x86_64            17.03.1.ce-1.el7.centos            @docker-ce-stable
  #   docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable
  #   Available Packages
  # Step2 : 安装指定版本的Docker-CE: (VERSION 例如上面的 17.03.0.ce.1-1.el7.centos)
  # sudo yum -y install docker-ce-[VERSION]
  # 注意：在某些版本之后，docker-ce安装出现了其他依赖包，如果安装失败的话请关注错误信息。例如 docker-ce 17.03 之后，需要先安装 docker-ce-selinux。
  # yum list docker-ce-selinux- --showduplicates | sort -r
  # sudo yum -y install docker-ce-selinux-[VERSION]

  echo "配置阿里镜像源-----------------------------------------------------"
  sudo mkdir -p /etc/docker
  echo '{"registry-mirrors": ["https://thu8zyqr.mirror.aliyuncs.com"]}' >> /etc/docker/daemon.json
  sudo systemctl daemon-reload
  sudo systemctl restart docker
fi

echo "配置目录权限---------------------------"
# 配置solr文件权限
if [ ! -d "../data/solr/cores/" ];then
  mkdir -p ../data/solr/cores/
  chown -R 8983:root ../data/solr/cores/
fi

#配置es ik分词插件
if [ ! -d "../data/elasticsearch/plugins" ];then
  yum install wget -y
  yum install unzip -y
  mkdir -p ../data/elasticsearch/plugins
  cd ../data/elasticsearch/plugins
  wget http://f.zyw.ink/elasticsearch/plugins/ik.zip
  unzip ik.zip
  rm -rf ik.zip
fi

# 配置开机启动脚本
chmod +x /etc/rc.d/rc.local
echo $PWD/rc.sh >> /etc/rc.d/rc.local 

# 配置docker开机启动
echo "systemctl restart docker && echo 启动docker >> $PWD/rc.log" >> rc.sh 






