FROM java

EXPOSE 8761

COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY eureka-ha.2.1.4.RELEASE.jar /eureka.jar

CMD ["/start.sh"]

