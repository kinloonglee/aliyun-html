#!/bin/bash

num=`seq 1 65535`
for i in $num
do
    echo $i|md5sum >>/tmp/a.txt  &

done


