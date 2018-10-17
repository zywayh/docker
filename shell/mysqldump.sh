#!/bin/sh

#host 要写外网域名,或者ip,或者能保证容器读取到的ip,不能写localhost
#./mysqldump.sh <host> <port> <pass> <databaseName> <path>

if [ $# -ge 5 ];then
    zcDATE=$(date +%Y%m%d%H%M%S)
    databaseName=$4
    savepath=$5/$databaseName-$zcDATE.sql
    docker run --rm -ti 865308221/mysql:5.7.18 mysqldump -h$1 --port=$2 -uroot -p$3 --databases $databaseName > $savepath
else
    echo "参数错误 <host> <port> <pass> <database name> "
fi
