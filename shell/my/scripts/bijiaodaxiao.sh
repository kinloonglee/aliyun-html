#!/bin/bash

read -p "请输入一个正整数:" -s -t 3 num1
echo $num1
a=$1
b=$2
pan1=`expr $a + 1  &>/dev/null` 
pan11=`echo $?`
pan2=`expr $b + 1 &>/dev/null`   
pan22=`echo $?`
if [ $# -ne 2 ]
	
   then 
	echo "请输入两个数字"
	exit 2
elif [[ $pan11 -ne 0 ||  $pan22 -ne 0 ]]
	then 
	echo "请输入整数"
	exit 1
elif  [ $a -gt $b ] &>/dev/null
	then
        echo "$a>$b"
elif   [ $a -lt $b ] &>/dev/null
       then 
        echo "$a<$b"
else
       echo "$a=$b"
fi



