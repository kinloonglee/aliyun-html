#!/bin/bash
source  /etc/init.d/functions
menu1(){
cat<<EOF

###########
1 更改主机名
2 更改ip地址主机位
3 退出
EOF
}

menu2(){
cat<<EOF

############_
请确定要更改吗
1  yes
2  no 
3  exit
EOF
}
PanDuan(){
   if [ $? -eq 0 ];then
      action "上条语句执行成功"  /bin/true
   else
         action "上条语句执行失败"  /bin/true
         exit 99
  fi
}

while true
do
menu1
read -p "请输入序号: " num1
case $num1 in
1)
    menu2
    read -p "请输入序号: "  num2
    case $num2 in
    1)
        read -p "请输入要更改的主机名: " name
        [ -z $name ] && echo "请输入主机名称" && exit
        hostnamectl set-hostname $name
        PanDuan
    ;;
    2)
       clear
       continue  
    ;;
    *)
       exit 
    esac
   ;;
2)
   menu2
    read -p "请输入序号: "  num2
    case $num2 in
    1)
        read -p "请输入要更改的ip地址主机位[10-254]: " IP
        [[ ! $IP =~ ^[0-9]+$ ]] && echo "请输入整数" && exit
        eth="/etc/sysconfig/network-scripts/ifcfg-eth0"
        SIP=`cat $eth|grep IPADDR|awk -F. '{print $NF}'`
        sed -i "s#$SIP#$IP#g"  $eth
        PanDuan
    ;;
    2)
       clean
       continue
    ;;
    3)
       exit 
    esac
    ;;
*)
    exit
esac
done
