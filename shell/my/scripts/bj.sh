#!/bin/bash
#输入两个数字
read -p "请输入第一个数字：" num1
# [ -z $num1 ] && echo "请输入内容"
 expr $num1 + 1 &>/dev/null
 [ $? -ne  0  ]  && echo "请输入整数" && exit 2
[ -z "$num1" ]&& exit 4

read -p "请输入第二个数字：" num2
# [ -z $num2 ] && echo "请输入内容" && exit 3
 expr $num2 + 1 &>/dev/null

 [ $? -ne  0  ]  && echo "请输入整数" && exit 2

[ -z "$num2" ]&& exit 5

[ $num1 -eq $num2 ] && echo "$num1 = $num2"  && exit 3
[ $num1 -gt $num2 ] && echo "$num1 > $num2"
[ $num1 -lt $num2 ] && echo "$num1 < $num2"
