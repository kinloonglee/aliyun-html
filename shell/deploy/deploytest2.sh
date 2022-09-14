#!/bin/bash
jar_name=$1
jar_base_name="${jar_name%.*}"
RESOURCE_PATH=/home/bikkt
SHELL_PATH=/home/bikkt/shell
DEPLOY_PATH=/home/deploy
export JAVA_HOME=/usr/local/jdk1.8.0_111
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib/
export PATH=$PATH:$JAVA_HOME/bin
source /etc/profile
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
if [ $? -eq 0 ];then
echo "mv $jar_name 成功"
else
echo "mv $jar_name 失败"
fi
script_name=$(sh  $DEPLOY_PATH/start_jars.sh $jar_name)
echo "$SHELL_PATH/${script_name}....................."
/bin/bash $SHELL_PATH/$script_name 
if [ $? -eq 0 ];then
echo "执行${script_name}成功"
else
echo "执行${script_name}失败"
fi

#nohup java -Xmx1G -Xms384M -Xmn640M -jar $RESOURCE_PATH/$jar_name > $RESOURCE_PATH/log/${jar_base_name}.out 2>&1 &
##BUILD_ID=dontKillMe nohup java -jar /application/data/$jar_name &
#echo "执行启动jar命令完毕.............."
