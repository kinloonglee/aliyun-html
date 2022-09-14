#!/bin/bash

> /tmp/ip.log
net=132.232
for j in {1..254};do
for i in {1..254}
do
    {
      if ping -c1 -w1 $net.$j.$i &>/dev/null;then
         echo $net.$j.$i  is up
         echo $net.$j.$i is up>>/tmp/ip.log
	   else
	      echo $net.$j.$i is down
      fi	  
	}&

done
done
wait
