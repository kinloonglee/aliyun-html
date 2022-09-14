#!/bin/bash

for ip in `seq 255`
do
 { 

 ping -c 1  211.88.253.$ip  &>/dev/null 
    if [ $? -eq 0 ]; then
     echo 211.88.253.$ip UP  
    else
      echo 211.88.253.$ip DOWN 
    fi
  }&


usleep 0.02 
done

