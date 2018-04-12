wget http://zyw-resource.oss-cn-beijing.aliyuncs.com/IKAnalyzer.jar
if [ $? -ne 0 ]; then
    wget http://zyw-resource.oss-cn-beijing.aliyuncs.com/IKAnalyzer.jar
fi

echo "编译solr-----------------------------------------------"
docker build -t ik.solr .
