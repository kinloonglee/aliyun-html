#!/bin/bash           //程序开始
#File: hosts_deny.sh
#Date: 2016-01-10

reg="^[0-9].*$"
tail -n 15000  /var/log/secure |grep 'Failed password'| awk '{print $11}' | uniq -c | sort -nrk1|awk '{if($1>5)print $0}'| \
#取出日志中登录失败的IP并统计排序
while read a b     #//读取统计结果
do
    grep -q $b /etc/hosts.deny    # //测试IP是否存在，存在为0
      if [ $? != 0 ] ; then
   #     if [ $a -ge 5 ] ; then  # //统计的次数大于等于5
         if [[ "$b" =~ $reg ]];then
            echo "sshd: $b" >> /etc/hosts.deny   # //添加IP到黑名单
          #  fi
         fi
      fi
  # echo "$a $b"
done               #程序结束

count=`wc -l /etc/hosts.deny|awk '{print $1}'`
if [[ $count -gt 100 ]];then
      sed '15,+10d' /etc/hosts.deny
fi
