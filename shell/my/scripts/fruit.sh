#!/bin/bash
##############################################################
# File Name: fruit.sh
# Version: V1.0
# Author: ljl
# Organization: www.oldboyedu.com
# Created Time : 2017-09-15 17:14:45
# Description:
##############################################################

redColor="\033[31m"
endColor="\033[0m"
huaColor="\033[33m"
blueColor="\033[36m"
zhiColor="\033[35m"
cat <<EOF
当前水果有
1.apple
2.orange
3.banana
4.xigua
EOF
while true
do
read -p "请输入你想要的水果序号:" num

case "$num" in
1)
    echo -e "$redColor apple $endColor"
    ;;
2)
    echo -e "$huaColor orange $endColor"
    ;;
3)
    echo -e "$huaColor orange $endColor"
    ;;
4)
    echo -e "$zhiColor orange $endColor"
    ;;
exit)
    exit
    ;;
*)
     echo "Usage: $0 [1|2|3|4]"
     echo "退出请输入exit"
esac
done
