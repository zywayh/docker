# docker
docker 服务器测试环境搭建使用的整个目录结构及可能使用到的脚本文件

# 目录结构
目录|简介
---|---
build|镜像编译文件目录
compose|常用的docker-compose.yml
data|镜像映射目录
project|存放项目的目录
shell|封装的脚本(可执行)文件

### build目录介绍
目录|简介
---|---
grails|grails运行镜像编译文件
sentinel|redis-sentinel运行镜像编译文件
solr|solr运行镜像编译文件(内置了ik分词器)

### compose目录介绍
目录|简介
---|---
activemq|
certbot|
elk|
eureka|
eureka-ha|
jenkins|
kafka|
mysql|
nginx|
openresty|
redis|
redis-sentinel|
registry|
solr|
zookeeper|
zookeeper-ha|

### shell目录介绍
目录|简介
---|---
baksql_test.sh|mysql备份demo
certbot.sh|ssl证书生成脚本
crontab.txt|定时任务demo
docker-install.sh|系统初始化安装docker
install-alioss.sh|安装阿里oss映射,可作为存储硬盘使用
iptables-install.sh|linux7防火墙关闭
mongodump.sh|docker镜像mongo数据库备份数据
mysqldump.sh|docker镜像mysql数据库备份数据
rc.sh|开机启动脚本,添加到开机任务中,文件中的shell可启动



