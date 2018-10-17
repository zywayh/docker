#!/bin/sh

if [ $# -ge 5 ];then
    zcDATE=$(date +%Y%m%d%H%M%S)
    databaseName=$4
    savepath=$5/$databaseName-$zcDATE.sql
    docker run --rm -ti 865308221/mysql:5.7.18 mysqldump -h$1 --port=$2 -uroot -p$3 --databases $databaseName > $savepath
else
    echo "参数错误 <host> <port> <pass> <database name> "
fi
