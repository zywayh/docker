#!/bin/sh

#定时任务   crontab -e

#$1 为需要备份数据库的镜像名称,/dbbak/目录为镜像内部目录,需要映射到本地
docker exec $1 sh -c '/usr/bin/mysqldump --set-gtid-purged=OFF -u root -pFlzx3000c --all-databases >/mysqlbak/all.sql'
#镜像内部映射到本地的目录
cd ../data/mysql/bak
zcDATE=$(date +%Y%m%d%H%M%S)
databaseName=$3
savepath=/dbbak/$zcDATE.sql.tgz
#压缩文件
tar czvf $savepath all.sql
rm all.sql
#将压缩过的文件转移到指定目录
mv $savepath  /ossfs/mysql/$1/
