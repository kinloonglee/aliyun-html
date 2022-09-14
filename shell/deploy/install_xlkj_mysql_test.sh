#!/bin/bash
#测试的
mysql_dir="/home/mysql5.7.28"
mysql_pre_dir="/home"
port=3306

project_path=$(cd "$(dirname "$0")"; pwd)
cd ${project_path}

function log(){

if [[ $? -eq 0 ]];then
  echo "$1" seccess ++++++++++++
  sleep 1
else
  echo "$1" failed ____________
  #exit 1
fi

}

#mysql_exist_num=$(find $mysql_pre_dir -name "*mysql*"|wc -l|grep -v grep)
#if [[ ${exist_num} -ne 0 ]];then
#   echo "mysql dir  $mysql_pre_dir/mysql exist!"
#   exit 2
#fi
#
#mysql_precess_num=$(ps -ef|grep mysql|grep -v grep)
#if [[ ${mysql_precess_num} -ne 0 ]];then
#   echo "mysql process ps -ef exist!"
#   exit 2
#fi
useradd -r -s /sbin/nologin -m mysql
log "create mysql user"


tar xf mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz  -C  $mysql_pre_dir
log "tar mysql.tar.gz "

cd $mysql_pre_dir
ls -l
mv  $mysql_pre_dir/mysql-5.7.28-linux-glibc2.12-x86_64   ${mysql_dir}
log "create soft link for mysql"
ls -l

echo "export PATH=${mysql_dir}/bin:$PATH" > /etc/profile.d/mysql.sh
source /etc/profile.d/mysql.sh
export PATH=${mysql_dir}/bin:$PATH
hash -d mysql
#yum安装mysql会找/var/lib/mysql/mysql.sock  清空他 默认安装会找/tmp/mysql.sock  
log "export PATH env "

mkdir -p ${mysql_dir}/{log,etc,run,data,binlogs}
chown -R mysql.mysql ${mysql_dir}/{data,binlogs,log,etc,run}
log "chown mysql privileges for directory"

rm -f /etc/my.cnf

cat > ${mysql_dir}/etc/my.cnf <<EOF
[client]
port = $port
socket = ${mysql_dir}/run/mysql.sock

 

[mysqld]
port = $port
socket = ${mysql_dir}/run/mysql.sock
pid_file = ${mysql_dir}/run/mysqld.pid
datadir = ${mysql_dir}/data
default_storage_engine = InnoDB
language =/home/mysql3306/share/english
max_allowed_packet = 512M
max_connections = 2048
open_files_limit = 65535

skip-name-resolve
lower_case_table_names=1

character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'


innodb_buffer_pool_size = 1024M
innodb_log_file_size = 2048M
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 0


key_buffer_size = 64M

log-error = ${mysql_dir}/log/mysql_error.log
log-bin = ${mysql_dir}/binlogs/mysql-bin
slow_query_log = 1
slow_query_log_file = ${mysql_dir}/log/mysql_slow_query.log
long_query_time = 2
log-queries-not-using-indexes = off


tmp_table_size = 32M
max_heap_table_size = 32M
query_cache_type = 0
query_cache_size = 0
server-id=1
EOF

log "${mysql_dir}/etc/my.cnf create"
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
Mem=`free -m | awk '/Mem:/{print $2}'`
echo  "free is ${Mem}"


 sed -i "s@max_connections.*@max_connections = $((${Mem}/3))@"  ${mysql_dir}/etc/my.cnf
  if [ ${Mem} -gt 1500 -a ${Mem} -le 2500 ]; then
    sed -i 's@^thread_cache_size.*@thread_cache_size = 16@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^query_cache_size.*@query_cache_size = 16M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 16M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^key_buffer_size.*@key_buffer_size = 16M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 128M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^tmp_table_size.*@tmp_table_size = 32M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^table_open_cache.*@table_open_cache = 256@' ${mysql_dir}/etc/my.cnf
  elif [ ${Mem} -gt 2500 -a ${Mem} -le 3500 ]; then
    sed -i 's@^thread_cache_size.*@thread_cache_size = 32@' ${mysql_dir}/etc/my.cnff
    sed -i 's@^query_cache_size.*@query_cache_size = 32M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 32M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^key_buffer_size.*@key_buffer_size = 64M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 512M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^tmp_table_size.*@tmp_table_size = 64M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^table_open_cache.*@table_open_cache = 512@' ${mysql_dir}/etc/my.cnf
  elif [ ${Mem} -gt 3500 ]; then
    sed -i 's@^thread_cache_size.*@thread_cache_size = 64@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^query_cache_size.*@query_cache_size = 64M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 64M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^key_buffer_size.*@key_buffer_size = 256M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 1024M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^tmp_table_size.*@tmp_table_size = 128M@' ${mysql_dir}/etc/my.cnf
    sed -i 's@^table_open_cache.*@table_open_cache = 1024@' ${mysql_dir}/etc/my.cnf
  fi






log "modify /etc/my.cnf "

yum install numactl -y  
log "install numactl.rpm "
 

echo "$(date +%F_%T)"
${mysql_dir}/bin/mysqld --defaults-file=${mysql_dir}/etc/my.cnf --initialize-insecure --user=mysql --basedir=${mysql_dir} --datadir=${mysql_dir}/data
echo "$(date +%F_%T)"
log "init mysql data"

mysql_ssl_rsa_setup --basedir=${mysql_dir} --datadir=${mysql_dir}/data/  &>/dev/null
log "ssl_rsa_setup "
cd /usr/lib/systemd/system
cat > mysqld.service<<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target

[Service]
User=mysql
Group=mysql

Type=forking

PIDFile=${mysql_dir}/run/mysqld.pid

# Disable service start and stop timeout logic of systemd for mysqld service.
TimeoutSec=0

# Execute pre and post scripts as root
PermissionsStartOnly=true

# Needed to create system tables
#ExecStartPre=/usr/bin/mysqld_pre_systemd

# Start main service
ExecStart=${mysql_dir}/bin/mysqld  --defaults-file=${mysql_dir}/etc/my.cnf --daemonize

# Use this to switch malloc implementation
EnvironmentFile=-/etc/sysconfig/mysql

# Sets open_files_limit
LimitNOFILE = 65535

Restart=on-failure

RestartPreventExitStatus=1

PrivateTmp=false
EOF

ln -s ${mysql_dir}/run/mysql.sock /tmp/mysql.sock

log "mysql.service file create "



systemctl daemon-reload
systemctl enable mysqld.service
systemctl is-enabled mysqld
systemctl start mysqld.service 
log "mysql start"





{

  second=0
  while true
  do
    mysql  -e "show databases;"
    if [[ $? -gt 0 ]];then
         echo "密码修改成功 "
		 source /etc/profile.d/mysql.sh
         ps -ef |grep "install.sh" |grep -v grep|awk '{print $2}' |xargs kill    &>/dev/null
         echo "密码修改成功 "
         break
    fi
	  
    if [[ ${second} -ge 10 ]];then
          echo "时间太长了,还没修改密码好"
          ps -ef |grep "install.sh" |grep -v grep|awk '{print $2}' |xargs kill    &>/dev/null
          break
    fi


        second=$((second + 2))
        sleep 2
#       echo "启动时长:  ${second} 秒"     
   
  done


}&


${mysql_dir}/bin/mysql   -e " ALTER USER USER() IDENTIFIED BY '123456';"









