#!/bin/bash


for i in oldboy{1..10}
do
  Passwd=`uuidgen`
  User=$i
   useradd $User &>/dev/null
   if [ $? -eq 0 ];then
       echo $Passwd|passwd --stdin $i
           if [ $? -eq 0 ]; then 
        echo "用户名密码添加成功"
	echo ${i} : $Passwd >> /tmp/user.txt
       fi
      else
   echo "用户添加失败,删除用户再添加"
   #Userdel=`cat /etc/passwd|awk -F "[:]" '$1~/^\${i}$/{print $1}'`
   id $User
   if [ $? -eq 0 ];then
   userdel -r $User
   fi
   if [ $? -eq 0 ];then
    echo "删除成功"
   sleep  0.5
    else
    echo "删除失败"

  fi
   
fi

done
