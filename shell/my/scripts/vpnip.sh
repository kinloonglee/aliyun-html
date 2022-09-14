#!/bin/bash

for ip in `seq 255`
do
 { 

 ping -c 1 10.8.0.$ip  &>/dev/null 
    if [ $? -eq 0 ]; then
     echo 10.8.0.$ip UP  
    fi
  }&


usleep 0.05 
done

