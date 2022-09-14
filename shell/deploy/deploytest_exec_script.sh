#!/bin/bash
jar_name=$1
jar_base_name="${jar_name%.*}"
RESOURCE_PATH=/home/bikkt
SHELL_PATH=$RESOURCE_PATH/shell
DEPLOY_PATH=/home/deploy
export JAVA_HOME=/usr/local/jdk1.8.0_111
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib/
export PATH=$PATH:$JAVA_HOME/bin
export TZ=Asia/Shanghai 
if [ ! -f /home/deploy/webapp/$jar_name ]     #如果目录里没有jenkins发送过来的jar包直接退出脚本
then
    echo "目录里没有jenkins发送过来的jar包:  $jar_name"
    exit 1
fi

if [ -f /home/bikkt/$jar_name ]     #将上一次的jar放到备份目录,并控制备份jar包的个数
then
    echo "backup /home/bikkt/  jar file  to   /home/deploy/webappbackup/"
    mv /home/bikkt/$jar_name  /home/deploy/webappbackup/${jar_base_name}-`date +"%Y%m%d-%H%M%S"`.jar
    backupapp_count=`ls /home/deploy/webappbackup/${jar_base_name}*|wc -l`
    #控制备份包数量不大于3个
    if [ "$backupapp_count" -gt "3" ]
    then
        rm_list=`ls -lt /home/deploy/webappbackup/${jar_base_name}*|awk '{print $9}'|grep -v "^$"|sed -n '4,$p'`
        for i in $rm_list
        do
          echo "remove the webappbackup jar:$i ..."
          rm -rf $i
        done

    fi

fi

echo "move the jar to /home/bikkt..."

mv  /home/deploy/webapp/$jar_name  /home/bikkt/$jar_name    #将jenkins发送来的jar包放到/home/bikkt目录下
#这里在jenkins里调用脚本 执行.
#script_name=($(sh  $DEPLOY_PATH/start_jars.sh $jar_name))
#if [[ $script_name  =~ ^.*currency.*$ ]];then
#for i in ${script_name[@]}
#do
#/bin/bash $SHELL_PATH/$i &>/dev/null
#echo "$SHELL_PATH/$i"
#done

#else
script_name=$(sh  $DEPLOY_PATH/start_jars.sh $jar_name)
echo "$SHELL_PATH/$script_name"
/bin/bash $SHELL_PATH/$script_name &>/dev/null
#fi
