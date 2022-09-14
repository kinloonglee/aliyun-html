#!/bin/bash
function rotate(){
 logs_path=$1
    echo Rotating Log:$1
    cp ${logs_path}  ${logs_path}.$(date -d yesterday +%Y%m%d:%H%M%S)
    > ${logs_path}
    rm -f ${logs_path}.$(date -d "7 days ago" +"%Y%m%d")
}
 for i in $*
do 
   rotate $i
done


