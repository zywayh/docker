# docker
docker 服务器测试环境搭建使用的整个目录结构及可能使用到的脚本文件

本文档使用教程绝大部分基于java spring boot，除非有特殊标识说明基于其他的框架或语言

# 快速使用

###  1：git clone https://github.com/zywayh/docker.git

### 2：cd ./docker/shell

### 3：执行脚本  ./install-docker.sh  安装docker和docker-compose

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

# 使用介绍

## RabbitMQ

### 启动

进入 compose目录下的rabbit文件夹

文件夹下存在docker-compose.yml文件

使用docker-compose up -d后台启动

### RabbitMQ 插件使用

* 启动docker容器后，执行下列语句开启关闭rabbitmq_delayed_message_exchange 

> 开启命令：docker exec rabbit sh -c "rabbitmq-plugins enable rabbitmq_delayed_message_exchange"
>
> 关闭命令：docker exec rabbit sh -c "rabbitmq-plugins disable rabbitmq_delayed_message_exchange"
>
> 查看插件列表：docker exec rabbit sh -c "rabbitmq-plugins list"

#### spring boot使用方法

* pom引入jar包

  ```xml
  <dependency>
  	<groupId>org.springframework.boot</groupId>
  	<artifactId>spring-boot-starter-amqp</artifactId>
  </dependency>
  ```

  

* 代码实现

  * 队列创建

    ```java
    import org.springframework.amqp.core.*;
    import org.springframework.context.annotation.Bean;
    import org.springframework.stereotype.Component;
    
    import java.util.HashMap;
    import java.util.Map;
    
    /**
     * @description:
     * @author: zhuyawei
     * @date: 2019-09-06 13:17
     */
    @Component
    public class RabbitMQConfig {
    
        /**
         * 定义queue名称
         */
        public static final String MQ_QUEUE_NAME = "QU_SHI";
    
        /**
         * 定义exchange
         */
        public static final String MQ_EXCHANGE_NAME = MQ_QUEUE_NAME;
    
        /**
         * 定义queue和exchange绑定使用的routingKey名称
         */
        public static final String MQ_ROUTING_KEY = MQ_EXCHANGE_NAME;
    
        /**
         * 创建消息队列
         * @return
         */
        @Bean
        public static Queue queue() {
            return new Queue(MQ_QUEUE_NAME);
        }
    
        /**
         * 创建自定义类型的exchange
         * 应用于延时消息队列使用，需与queue进行bind
         * @return
         */
        @Bean
        public static CustomExchange exchange() {
            Map<String, Object> arguments = new HashMap<>();
            arguments.put("x-delayed-type", "direct");
            return new CustomExchange(MQ_EXCHANGE_NAME, "x-delayed-message", true, false, arguments);
        }
    
        /**
         * queue和自定义exchange进行绑定
         * @param queue
         * @param exchange
         * @return
         */
        @Bean
        Binding bindingExchangeMessages(Queue queue, CustomExchange exchange) {
            return BindingBuilder.bind(queue).to(exchange).with(MQ_ROUTING_KEY).noargs();
        }
    
    //    /**
    //     * 创建RabbitMQ指定类型的
    //     * @return
    //     */
    //    @Bean
    //    TopicExchange topicExchange() {
    //        return new TopicExchange(MQ_EXCHANGE_NAME);
    //    }
    //
    //    /**
    //     * queue和exchange进行绑定
    //     * 创建普通非延时exchange及绑定，如无特殊需求，在非延时队列并不需要创建exchange
    //     * @param queueMessages
    //     * @param topicExchange
    //     * @return
    //     */
    //    @Bean
    //    Binding bindingExchangeMessages(Queue queueMessages, TopicExchange topicExchange) {
    //        return BindingBuilder.bind(queueMessages).to(topicExchange).with(MQ_ROUTING_KEY);
    //    }
    
    }
    ```

    

  * 生产者及消费者

    ```java
    import com.trend.config.RabbitMQConfig;
    import org.springframework.amqp.core.AmqpTemplate;
    import org.springframework.amqp.core.Message;
    import org.springframework.amqp.core.MessageProperties;
    import org.springframework.amqp.rabbit.annotation.RabbitListener;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Component;
    
    /**
     * @description: mq 工具类，其中包含生产者及消费者，
     * @author: zhuyawei
     * @date: 2019-09-06 13:19
     */
    @Component
    public class MqUtil {
    
        private static AmqpTemplate rabbitTemplate;
    
        @Autowired
        private void setRabbitTemplate(AmqpTemplate rabbitTemplate){
            MqUtil.rabbitTemplate = rabbitTemplate;
        }
    
        /**
         * 发送消息
         * @param msg   消息体
         */
        public static void send(String msg) {
            send(msg, 0);
        }
    
        /**
         * 发送延时消息
         * @param msg   消息体
         * @param delay 延时时间，如果为空，或者=0，或者小于0不延时
         */
        public static void send(String msg, Integer delay) {
            if(delay <= 0){
                rabbitTemplate.convertAndSend(RabbitMQConfig.MQ_ROUTING_KEY, msg);
            }else{
                MessageProperties properties = new MessageProperties();
                properties.setDelay(delay);
                Message message = new Message(msg.getBytes(), properties);
                rabbitTemplate.send(RabbitMQConfig.MQ_EXCHANGE_NAME, RabbitMQConfig.MQ_ROUTING_KEY, message);
            }
        }
    
        /**
         * 消费消息（处理逻辑请另行定义）
         * @param message
         */
        @RabbitListener(queues = RabbitMQConfig.MQ_QUEUE_NAME)
        private void process(Message message) {
            System.out.println("消息消费：" + new String(message.getBody()));
        }
    }
    
    ```

    

## openresty 简单使用

> 使用时请先链接docker-compose.yml文件中的links，使其能够连通redis进行使用

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



## 个人博客 Jpress

> 使用注意事项
>
> * 需手动创建数据库，需要时utf8mb4格式
> * 无法评论的问题，需要在 “文章” -> “设置” -> “评论功能”中开启评论 
> * **注意事项：每日删除容器，重新创建启动后，需要配置数据库连接**

