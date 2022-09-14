#!/bin/bash
#
# cat user.txt
#  ljl 123
#  abc 456
#
#
while read line
do
  user=`echo $line|awk '{print $1}'`
  passwd=`echo $line|awk '{print $2}'`
  useradd $user
  echo $pass|passwd --stdin $user
done<user.txt
