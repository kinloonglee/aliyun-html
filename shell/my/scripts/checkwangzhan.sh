#!/bin/bash
#Author:ZhangGe
#Date：2014-08-21
#Desc：Check the site of ZGboke Alliance.
#取出网站数据
data=`cat /server/scripts/wangzhanmulu.txt`
if [ -z "$data" ];then
    echo "Faild to connect database!"
    exit 1
fi
test -f result.log && rm -f result.log
function delay {
    sleep 3
}
tmp_fifofile=/tmp/$$.fifo
mkfifo $tmp_fifofile
exec 6<>$tmp_fifofile
rm $tmp_fifofile
#定义并发线程数，需根据vps配置进行调整。
thread=100
for ((i=0 ;i<$thread;i++ ))
do
    echo
done>&6
#开始多线程循环检测
for url in $data
do
    read -u6
    {
    #curl抓取网站http状态码
    code=`curl -o /dev/null --retry 3 --retry-max-time 8 -s -w %{http_code} $url`
    echo "$code ---> $url">>result.log  
    #判断子线程是否执行成功，并输出结果
    delay && {
        echo "$code ---> $url"
    } || {
        echo "Check thread error!"
    }
    echo >& 6
}&
done
#等待所有线程执行完毕
wait
exec 6>&-
#找出非200返回码的站点
echo List of exception website:
#cat result.log | grep -v 200
for i in `grep -v 200 result.log`
do
  mail -s 

done

exit 0
