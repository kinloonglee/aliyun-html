#!/bin/bash
file=$1
newfile=$2
filename=`basename$file`
if [ -d $newfile ];then
    newfile=$newfile/$filename
fi
cp $file $newfile &
CP_PID=$!
trap 'kill -9 $CP_PID' INT
size_old=`stat -c"%s" $file`
size_new=`stat -c"%s" $newfile`
(
while [ $size_new -lt $size_old ]
do
    echo "$size_new * 100 / $size_old"|bc
    sleep1
    size_new=`stat -c"%s"$newfile`
done
) | dialog --title"File Copy"--gauge"cp $file $newfile"10 70 0
