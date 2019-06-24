#!/bin/bash
message1=$1
message2=$2

URL=https://oapi.dingtalk.com/robot/send?access_token=a30323bc886c3c94713bbf606d986f8089d5232bdbe223c6818b974c54c8fcd9
result=$(curl -H "Content-type: application/json" -X POST -s -w %{http_code} -d '{"msgtype": "text","text": {"content": "'${message1} ${message2}'"}}' ${URL})
echo $result