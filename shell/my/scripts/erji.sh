#!/bin/bash
. /etc/init.d/functions

LAMPfile=/server/scripts/installlamp.sh
LNMPfile=/server/scripts/installlnmp.sh
menu1(){
cat <<EOF
1.install LAMP
2.install LNMP
3.exit
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

menu2(){
cat <<EOF
1.yes
2.no,go back
3.exit
EOF
}

while true
do 
menu1
read -p "please input num:" a
case "$a" in
1)
      menu2
      read -p "are you sure want install LAMP:"  b
      case  "$b" in 
      1)
         if [ -f ${LAMPfile} ];then
          sh ${LAMPfile}
          PanDuan
          break
           else
          echo "文件不存在,请给出文件"
          break
         fi
          ;;
       2)
         clear
         continue
          ;;
         3)
           exit
      esac
      ;;
2)
      menu2
        read -p "are you sure want install LNMP:"  b
    case  "$b" in
      1)
         if [ -f ${LNMPfile} ];then
          sh ${LNMPfile}
          PanDuan
          break
           else
          echo "文件不存在,请给出文件"
          break
         fi
          ;;
       2)
         clear
         continue
          ;;
         3)
           exit
      esac
      ;;
3)
      exit
esac
done
