#!/bin/bash
trap "请不要乱按."  INT TSTP HUP
WEB1=192.168.1.60
k8snode3=192.168.1.14

menu(){
cat<<EOF

_________
1.WEB1=192.168.1.60
2.k8snode3=192.168.1.14
3.menu
__________


EOF
}
menu
while true
do
read -p "请输入需要连接的服务器[1|WEB1]: " num
case  $num in
1|WEB1)
   ssh root@$WEB1
   trap "请不要乱按."  INT TSTP HUP
    ;;
2|k8snode3)
   ssh root@${k8snode3}
   trap "请不要乱按."  INT TSTP HUP
    ;;
3|menu)
   menu
   trap "请不要乱按."  INT TSTP HUP
    ;;
woshiyunwei|ljl)
    exit
    ;;
*)
  echo "输入要连接的服务器"
  menu
  trap "请不要乱按."  INT TSTP HUP
esac
done
