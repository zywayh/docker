#!/bin/sh
imageName=$1
databaseName=$2

Y=$(date +%Y)
m=$(date +%m)
d=$(date +%d)
H=$(date +%H)
M=$(date +%M)
S=$(date +%S)

savepath=/dbbak/mongo/

docker exec $imageName sh -c 'mongodump -h 127.0.0.1 -d '$databaseName' -o '$savepath
cd $savepath

osspath=/ossfs/mongo/$databaseName/$Y/$m/$d
mkdir -p $osspath
savepath=$osspath/$H.$databaseName.bson.tgz
tar czvf $savepath $databaseName
#rm -rf $databaseName

