#!/bin/sh

sed -i "s/\$MASTER_NAME/$MASTER_NAME/g" /sentinel.conf
sed -i "s/\$MASTER_IP/$MASTER_IP/g" /sentinel.conf
sed -i "s/\$MASTER_PORT/$MASTER_PORT/g" /sentinel.conf
sed -i "s/\$SENTINEL_QUORUM/$SENTINEL_QUORUM/g" /sentinel.conf
sed -i "s/\$SENTINEL_DOWN_AFTER/$SENTINEL_DOWN_AFTER/g" /sentinel.conf
sed -i "s/\$NUMREPLICES/$NUMREPLICES/g" /sentinel.conf
sed -i "s/\$SENTINEL_FAILOVER/$SENTINEL_FAILOVER/g" /sentinel.conf

exec docker-entrypoint.sh redis-sentinel /etc/redis/sentinel.conf 