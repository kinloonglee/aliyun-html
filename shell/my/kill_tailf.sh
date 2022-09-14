#!/bin/sh

if [ $# -le 1 -a $# -ge 3  ];then
    echo "请输入两位正确参数"
    exit 1
fi
echo "$1,$2"
des_log=$1/$2

#echo "项目日志为：$des_log"
second=0
echo "" > /mnt/scripts/log/boole_jvm_log

while true
do
     sum_jvm=`cat ${des_log} |grep 'JVM running for'|wc -l`
     echo "[tags] second: $second sum_jvm: $sum_jvm"
     echo "${sum_jvm}" > $1/log/boole_jvm_log

     if [[ ${second} -ge 5 ]];then
          echo "部署等待时间过长 退出部署"
          ps -ef |grep "tailf ${des_log}" |grep -v grep|awk '{print $2}' |xargs kill
          break
     fi

     if [[ ${sum_jvm} -gt 0 ]];then
         echo "[tags] sum_jvm ${sum_jvm} "
         ps -ef |grep "tailf ${des_log}" |grep -v grep|awk '{print $2}' |xargs kill
         echo "[tags] 项目启动花费 $second 秒"
         break
    fi
        second=$((second + 2))
        sleep 2
        echo "[tags] 启动时长second ${second}"
done

