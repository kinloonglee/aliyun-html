#!/bin/bash
while true
do
cat <<EOF
1.[install lamp]
2.[install lnmp]
3.[exit]
EOF

read -p "pls input the num you want:" num
case "$num" in
1)
   echo -e "start installing lamp."
   sleep 1
  /bin/sh /server/scripts/lamp.sh
   echo 
   sleep 1
   ;;
2)
     echo -e "start installing lnmp."
   sleep 1
    /bin/sh /server/scripts/lnmp.sh
    echo 
    sleep 1
   ;;
3)
   exit
   ;;
*)
   echo "Input error"
   echo
   sleep 1
esac
done
