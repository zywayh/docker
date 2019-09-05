# docker
docker 服务器测试环境搭建使用的整个目录结构及可能使用到的脚本文件

# 快速使用
### 1：git clone https://github.com/zywayh/docker.git
### 2：cd ./docker/shell
### 3：执行脚本  ./docker-install.sh  安装docker和docker-compose
### 4：进入compose，找到想使用的服务，进入文件夹
### 5：执行命令 docker-compose up -d 启动服务   docker-compose down 关闭服务

# 目录结构
目录|简介
---|---
build|镜像编译文件目录
compose|常用的docker-compose.yml
data|镜像映射目录
project|存放项目的目录
shell|封装的脚本(可执行)文件

### build目录介绍
目录|简介
---|---
grails|grails运行镜像编译文件
sentinel|redis-sentinel运行镜像编译文件
solr|solr运行镜像编译文件(内置了ik分词器)

### compose目录介绍
目录|简介
---|---
activemq|
certbot|
elk|
eureka|
eureka-ha|
jenkins|
kafka|使用kafka是请启动zk，并将docker-compose.yml中
mysql|
nginx|
openresty|需配置docker-compose links：redis链接才可以使用redis
redis|
redis-sentinel|
registry|
solr|ik分词器请自行配置
zookeeper|
zookeeper-ha|

### shell目录介绍
目录|简介
---|---
baksql_test.sh|mysql备份demo
certbot.sh|ssl证书生成脚本
crontab.txt|定时任务demo
docker-install.sh|系统初始化安装docker
install-alioss.sh|安装阿里oss映射,可作为存储硬盘使用
iptables-install.sh|linux7防火墙关闭
mongodump.sh|docker镜像mongo数据库备份数据
mysqldump.sh|docker镜像mysql数据库备份数据
rc.sh|开机启动脚本,添加到开机任务中,文件中的shell可启动



#### openresty 简单使用

```js
$.ajax({
	url: "/set",
	data: {key: "",val: "val"},
	dataType: "text",
	success: function(data){
		$('#resText').append(data);
		if(data == "+OK"){
			$('#resText').append("<div>true</div>");
		}else{
			$('#resText').append("<div>false</div>");
		}
	}
});
$.ajax({
	url: "/get",
	data: {key: "t2est"},
	dataType: "text",
	success: function(data){
		$('#resText').append(data);
		var list = data.split("\n")
		if(list.length > 0){
			$('#resText').append("<div>" + list[1] + "</div>");
		}else{
			$('#resText').append("<div>" + 获取失败 + "</div>");
		}
	}
});
```



