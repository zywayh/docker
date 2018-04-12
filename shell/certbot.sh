cd ../compose/certbot
echo "命令后添加 renew, 执行续签域名"
echo "执行需要填写邮箱地址,接收条款,A Y 两次,最后填写需要ssl的域名(服务器需要打开80,443端口才能成功,需要先停止nginx服务,必须在域名绑定的主机上操作)"
docker-compose run --rm --service-ports certbot $1
# Need to renew ? shell followed at add "renew"
# docker-compose run --rm --service-ports certbot renew


