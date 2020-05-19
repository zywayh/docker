#!/bin/sh
# 定时任务   crontab -e
if [ $# -ge 4 ];then
	# docker容器名称
	imageName=$1
	# 数据库密码
	password=$2
	# 备份的数据库名称
	databaseName=$3
	# 镜像内部映射到本地的目录
	savepath=$4
	# 拼接sql名称
	sqlName=$databaseName.sql
	# 备份命令
	mkdir -p ./log
	echo "\n备份时间：$(date +%Y%m%d%H%M%S)，备份数据库：$databaseName" >> ./log/mysql_bak.log
	docker exec $imageName sh -c '/usr/bin/mysqldump --set-gtid-purged=OFF -uroot -p'$password' '$databaseName' >/bak/'$sqlName 2>> ./log/mysql_bak.log
	if [ ! $? -ne 0 ]; then 
		# 判断备份是否成功
		cd $savepath
		if [ -f "$sqlName" ];then
			# 压缩文件
			# zcDATE=$(date +%Y%m%d%H%M%S)
			zcDATE=$(date +%Y%m%d%H)
			# 定义zip压缩文件路径
			zip_file=$databaseName.sql.$zcDATE.tgz
			# 压缩sql文件
			tar zcvf $zip_file $sqlName
			# 删除无用的.sql文件
			rm $sqlName
			Y=$(date +%Y)
			m=$(date +%m)
			w=$(date +%w)
			d=$(date +%d)
			# H=$(date +%H)
			# M=$(date +%M)
			# S=$(date +%S)

			# 本地测试
			local_path=./data_bak/$imageName/$Y/$m/$d
			if [ ! -d "$local_path" ]; then
				mkdir -p $local_path
			fi
			cp $zip_file $local_path

		else
			echo "sql导出失败"
		fi	
	fi
else
    echo "参数错误 <imageName> <password> <databaseName> <savepath>"
    echo "imageName：docker 容器名称"
    echo "password：mysql root用户的密码"
    echo "databaseName：要备份的数据库名称"
    echo "savepath：sql备份后，备份的sql文件在宿主机的文件夹位置"
fi






