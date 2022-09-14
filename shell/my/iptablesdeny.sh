#!/bin/bash
iptables -F
time="`date +%F|tr -d "-"`"
awk '{a[$2]++}END{for(i in a){print i,a[i]}}' /usr/trade2cnlogger/log/access${time}.log|sort -nrk2|sed  '/211.88.33.218/d'|sed  '/211.88.33.162/d' >/root/iptablesdeny.txt
DEFINE="5000"
cat     /root/iptablesdeny.txt |    while read LINE
do
               NUM=`echo $LINE |awk '{print $2}'`
               host=`echo $LINE    |awk '{print $1}'`
               if [ $NUM -gt $DEFINE ];
               then
                   iptables -nL| grep $host > /dev/null
                   if [ $? -gt 0 ];
                   then
                    iptables -I INPUT -p tcp -s $host --dport 8000 -j DROP
                   fi
               fi
done
