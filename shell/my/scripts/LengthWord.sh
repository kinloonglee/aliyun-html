#!/bin/bash

for i in `echo "I am oldboy teacher welcome to oldboy trainingclass"`
do 
   num=`echo $i|wc -L`
    if [ $num -le 6 ];then
      echo $i
    fi
done
