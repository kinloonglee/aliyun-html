#!/bin/bash

num=`seq 1 32767`
for i in $num
do
      a=`echo $i|md5sum` &>/dev/null  
     for j in `cat /oldboy/test.txt`
      do 
     if [[  "$a" =~ "$j" ]];then
        echo ${i}    $j
    fi
done 

done




