#!/bin/bash
. /server/scripts/oldboyedu_fun.sh
int_judge $1
echo $?

input_judge $1
echo $?


. /server/scripts/oldboyedu_fun.sh 


scripts_init
writelog "this is log"
echo 'hahha'
sleep 50
closeout

