#!/bin/sh

# 定时任务   crontab -e

imageName=$1
password=$2
databaseName=$3

# $1 为需要备份数据库的镜像名称,/bak/目录为镜像内部目录,需要映射到本地
# $2 为数据库密码
docker exec $imageName sh -c '/usr/bin/mysqldump --set-gtid-purged=OFF -u root -p '$password' --database '$databaseName' >/bak/all.sql'

# 镜像内部映射到本地的目录
savepath=../data/mysql/bak

# 压缩文件
zcDATE=$(date +%Y%m%d%H%M%S)
tar czvf $savepath/$zcDATE.sql.tgz $savepath/all.sql

# 删除无用的.sql文件
# rm all.sql

# 将压缩过的文件转移到指定目录
# mv $savepath  /ossfs/mysql/$1/
