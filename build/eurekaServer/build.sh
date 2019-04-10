
if [ ! -f "eureka-ha.2.1.4.RELEASE.jar" ]; then
 	wget http://zyw-file.oss-cn-beijing.aliyuncs.com/eureka-ha.2.1.4.RELEASE.jar
	if [ $? -ne 0 ]; then
		yum install wget -y
	    wget http://zyw-file.oss-cn-beijing.aliyuncs.com/eureka-ha.2.1.4.RELEASE.jar
	fi
fi

echo "编译 eureka -----------------------------------------------"
docker build -t spring-cloud-starter-netflix-eureka-server-ha .
