#!/usr/bin/env sh
cat /etc/profile|grep PS1

if [[ $? -ne 0 ]];then
echo "PS1='\[\e[32;1m\][\u@\h \W]$ \[\e[0m\]'" >>/etc/profile
fi
source /etc/profile
