#!/bin/bash

Char=`echo "I am oldboy teacher welcome to oldboy trainingclass"`
for i in $Char
do
   num=`echo $i|wc -L`
   if [ $num -le 6 ];then
    echo $i
	
    fi

done
