#!/bin/bash
#for i in {1..32767}
#do 
#   echo $i  `echo $i|md5sum` >>/tmp/passwd.txt 
#done
  
for j in `cat /tmp/test.txt`
do
    l=`grep $j  /tmp/passwd.txt` &>/dev/null
     if [ $? -eq 0 ];then
     echo $l
     fi
done
