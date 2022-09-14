#!/bin/bash
for i in `seq 1 43`
do 

       Pi=`curl -s  http://www.xiaohuar.com/list-1-${i}.html|egrep -o "/d.*.jpg"`
        for j in $Pi
do 
      echo ${j}|sed -r 's#(.*)#wget -P /tmp/abc www.xiaohuar.com\1#g'|bash >/dev/null
   done    
done
