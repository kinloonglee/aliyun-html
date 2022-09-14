#!/bin/bash

ListFile=`ls /oldboy`
cd /oldboy
for i in $ListFile

     do 
     echo $i|sed -r 's#(.*)(_.*)#mv & \1oldgirl.html#g'|bash
 #   rename oldboy oldgirl $i
done
