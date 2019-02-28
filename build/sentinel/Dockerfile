FROM redis

EXPOSE 6379
EXPOSE 26379

ADD sentinel.conf /sentinel.conf
RUN chown redis:redis /sentinel.conf

# sentinel monitor <master-name> <ip> <redis-port> <quorum>
ENV MASTER_NAME mymaster 	
ENV MASTER_IP redis-master
ENV MASTER_PORT 6379
ENV SENTINEL_QUORUM 1

# sentinel down-after-milliseconds <master-name> <milliseconds>
ENV SENTINEL_DOWN_AFTER 30000

# sentinel parallel-syncs <master-name> <numreplicas>
ENV NUMREPLICES 1

# sentinel failover-timeout <master-name> <milliseconds>
ENV SENTINEL_FAILOVER 180000

COPY sentinel.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/sentinel.sh

ENTRYPOINT ["sentinel.sh"]

# CMD ["redis-sentinel /sentinel.conf"]

