#!/bin/bash
##############################################################
# File Name: for1.sh
# Version: V1.0
# Author: ljl
# Organization: www.oldboyedu.com
# Created Time : 2017-09-15 17:43:38
# Description:
##############################################################

[ -d /test ]|| mkdir /test
cd /test

for i in $(seq 10)
	do
            touch  oldboy_$i.txt


 done
