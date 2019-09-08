# docker
docker 服务器测试环境搭建使用的整个目录结构及可能使用到的脚本文件

# 快速使用
###  1：git clone https://github.com/zywayh/docker.git

### 2：cd ./docker/shell

### 3：执行脚本  ./docker-install.sh  安装docker和docker-compose

### 4：进入compose，找到想使用的服务，进入文件夹

### 5：执行命令 docker-compose up -d 启动服务   docker-compose down 关闭服务

# docker 命令说明

* 启动创建好的容器：docker start 启动的容器名称
* 停止启动的容器：docker stop 启动的容器名称
* 重启停止的或启动中容器：docker restart 启动的容器名称
* 查看容器日志：docker logs -f --tail 100 启动的容器名称
* 进入容器bash命令行：docker exec -ti 启动的容器名称 bash

# docker-compose 命令说明

> 在运行命令的目录下需存在docker-compose.yml文件

* 启动编排好的容器：docker-compose up -d
* 停止并删除编排好的容器：docker-compose down 

# 目录结构

目录|简介
---|---
build|镜像编译文件目录
compose|常用的docker-compose.yml
conf|存放所有镜像所需的配置文件映射
data|存放所有镜像产生的数据映射
html|存放前端代码映射
project|存放项目的目录映射
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
certbot.sh| ssl证书生成脚本                                   
crontab.txt|定时任务demo
install-docker.sh|系统初始化安装docker
install-alioss.sh|安装阿里oss映射,可作为存储硬盘使用
 mongodump.sh      | docker镜像mongo数据库备份数据                     
 mysqldump.sh      | docker镜像mysql数据库备份数据                     
 rc.sh             | 开机启动脚本,添加到开机任务中,文件中的shell可启动 
 vue.sh            | vue编译脚本                                       
 webhook.sh        | 钉钉的webhook喝水提醒通知脚本                     

#### RabbitMQ 插件 rabbitmq_delayed_message_exchange 开启

> 开启命令：docker exec rabbit sh -c "rabbitmq-plugins enable rabbitmq_delayed_message_exchange"
>
> 关闭命令：docker exec rabbit sh -c "rabbitmq-plugins disable rabbitmq_delayed_message_exchange"
>
> 查看插件列表：docker exec rabbit sh -c "rabbitmq-plugins list"

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



