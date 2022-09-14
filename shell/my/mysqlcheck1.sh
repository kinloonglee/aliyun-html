#!/bin/bash
CURRENT_DIR=$(cd "$(dirname "$0")";pwd)
cd $CURRENT_DIR

execute_ssh_cmd="sshpass -pljl ssh -o StrictHostKeyChecking=no ljl@10.0.0.71"


main(){

#execute_ssh_cmd 10.0.0.70 root "123456" "mysql -uroot -p123456 -e 'show databases;' 2>/dev/null" test.log
${execute_ssh_cmd} "mysql -uroot -p123456 -e 'show databases;'" > $CURRENT_DIR/oracle.log  2>/dev/null
#mysql_status=$(sed '1,4d' $CURRENT_DIR/oracle.log|tac|sed '1,3d'|grep mysql|wc -l)
mysql_status=$(cat $CURRENT_DIR/oracle.log|grep mysql|grep -v grep|wc -l)
if [ $mysql_status -eq 1  ];then
  echo 0
else 
 echo 1
fi


}
main "$@"
