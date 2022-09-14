#!/bin/bash

.  /etc/init.d/functions
  for i in 47.{1..250}.{1..10}.{1..254}
     
    do
  # sleep  0.003

   {  ping -c 1 -w 1 $i &>/dev/null 
    if [  $? -eq 0  ];then
     action "$i"  /bin/true

    fi
} &



done
