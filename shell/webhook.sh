#!/bin/bash
message="大家该喝水了，每小时200毫升水，让你的肾更健康，让你的容颜更美丽！"
URL=https://oapi.dingtalk.com/robot/send?access_token=a30323bc886c3c94713bbf606d986f8089d5232bdbe223c6818b974c54c8fcd9
result=$(curl -H "Content-type: application/json" -X POST -s -w %{http_code} -d '{"msgtype": "text","text": {"content": "'${message}'"}}' ${URL})
echo $result