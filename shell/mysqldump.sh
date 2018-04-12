#!/bin/sh

if [ $# -ge 4 ];then
    zcDATE=$(date +%Y%m%d%H%M%S)
    databaseName=$3
    savepath=$4$databaseName-$zcDATE.sql
    docker run --rm -ti mysql mysqldump -h $1 -uroot -p$2 --databases $databaseName > $savepath
else
    echo "参数错误 <host> <pass> <database name> "
fi
