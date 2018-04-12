wget http://zyw-resource.oss-cn-beijing.aliyuncs.com/grails-3.3.1.zip
if [ $? -ne 0 ]; then 
    wget http://zyw-resource.oss-cn-beijing.aliyuncs.com/grails-3.3.1.zip
fi

echo "编译grails-----------------------------------------------"
docker build -t grails .




