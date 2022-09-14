#!/bin/sh
tail_script_dir=/home/deploy

if [ $# -le 1 -o $# -ge 3 ];then
    echo "请输入两位正确参数"
    exit 1
fi

dir=$1      #日志目录
name=$2    #日志文件名

{
des_log=$1/$2
echo "项目日志为：$des_log"
second=0
echo "" > $tail_script_dir/boole_jvm_log

while true
do
     sum_jvm=`grep 'JVM running for'  ${des_log}|wc -l`
#     echo "second: $second 秒      sum_jvm: $sum_jvm"
     echo "${sum_jvm}" > $tail_script_dir/boole_jvm_log

     if [[ ${second} -ge 40 ]];then
          echo "部署等待时间过长 退出部署"
          ps -ef |grep "tailf ${des_log}" |grep -v grep|awk '{print $2}' |xargs kill  &>/dev/null
          break
     fi

     if [[ ${sum_jvm} -gt 0 ]];then
         echo "sum_jvm       ${sum_jvm} "
         ps -ef |grep "tailf ${des_log}" |grep -v grep|awk '{print $2}' |xargs kill    &>/dev/null
         echo "项目启动花费 $second 秒"
         break
    fi
        second=$((second + 2))
        sleep 2
#        echo "启动时长:  ${second} 秒"
done

}&

#echo "执行shell命令： tailf  $dir/$name"
/usr/bin/tailf  $dir/$name


#echo [tags] tailf 命令已经成功退出
# 判断是否捕获到 Started .* second

sum_jvm=`cat  $tail_script_dir/boole_jvm_log`

if [ $sum_jvm -gt 0 ];then
echo "本次部署成功"
else
echo " 本次部署失败"
fi
