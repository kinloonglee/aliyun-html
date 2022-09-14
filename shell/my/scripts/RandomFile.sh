#!/bin/bash



[ ! -d /oldboy ] &&  mkdir /oldboy
cd /oldboy
for i in `seq 10`
   do
    RanWord=`uuidgen|tr '0-9-' 'a-z'|cut -c 1-8`
    touch ${RanWord}_oldboy.html
done
