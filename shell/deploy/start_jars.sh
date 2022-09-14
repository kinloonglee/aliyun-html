#!/bin/bash
#jar_path="/home/deploy/webapp"

if [ -z $1 ];then
echo "请输入jar包名称来获取启动jar包的脚本 ............"
echo "例如: sh test.sh  xxx.jar"
fi

#取中间的名字
mid_name(){       #bittrade-admin.jar restart-admin.sh
   jarname=$1
   mid_name1=${jarname%.*}
   mid_name2=${mid_name1#*-}
    echo "$mid_name2"
}
#去除.jar 取前面的名字   #wallet-biz.jar  restart-wallet-biz.sh
before_name(){
   jarname=$1
   mid_name1=${jarname%.*}
   echo "$mid_name1"
}
c2c_name(){      #  bikkt_c2c-1.0-SNAPSHOT.jar   restart-c2c.sh
   jarname=$1
   mid_name1=${jarname%%-*}
   mid_name2=${mid_name1#*_}
   echo "$mid_name2"


}

gateway_name(){      # bikkt-gateway-1.0-SNAPSHOT.jar  restart-gateway.sh
   jarname=$1
   
   mid_name1=${jarname#*-}
   mid_name2=${mid_name1%%-*}
   echo "$mid_name2"


}



eureka_name(){    #eureka-1.jar   restart-eureka.sh
   jarname=$1
   mid_name1=${jarname%-*}
   echo "$mid_name1"

}



get_shell_name(){
if [[ $1 =~ ^b.*$ ]];then
   if [[ $1 =~ ^bikkt_c2c.*$ ]];then
       mname=$(c2c_name $1)
       echo restart-$mname.sh
   elif  [[ $1 =~ ^bikkt-gateway.*$ ]];then
       mname=$(gateway_name $1)
       echo restart-$mname.sh

   elif [[ $1 =~ ^bikkt_wallet.*$ ]];then
       mname=$(c2c_name $1)
       echo restart-bikkt-$mname.sh

   else
       mname=$(mid_name $1)
       echo restart-$mname.sh
   fi
elif [[ $1 =~ ^w.*$ ]];then
   mname=$(before_name $1)  
   echo restart-$mname.sh
elif [[ $1 =~ ^eure.*$ ]];then
   mname=$(eureka_name $1)
   echo restart-$mname.sh

fi
}

get_shell_name  $1 
