#!/bin/bash
mysql_dir="/home/mysql"
mysql_pre_dir=${mysql_dir%/*}
port=3307
root_mysql_passwd="123456"
mysql_bin_code="mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz"


mysql_install_version=${mysql_bin_code%.tar.gz}

#mysql_install_version=`echo $mysql_bin_code|awk -F'.tar.gz' '{print $1}'`

#systemctl disable avahi-daemon
#systemctl stop avahi-daemon

project_path=$(cd "$(dirname "$0")"; pwd)
cd ${project_path}

function log(){

if [[ $? -eq 0 ]];then
  echo "$1" seccess ++++++++++++
  sleep 1
else
  echo "$1" failed ____________
  exit 1
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
id mysql || useradd -r -s /sbin/nologin -m mysql
id mysql &&  echo "mysql用户安装成功"

if [ ! -d /home/$mysql_install_version ] 
   then
       echo "mysql目录不存在 ,可以安装 "
       if [ ! -f ${mysql_install_version}.tar.gz ] ;then
           echo "mysql安装包不存在或者版本不对"
           exit  11
       fi
       tar xf ${mysql_install_version}.tar.gz -C  $mysql_pre_dir
else

        echo "mysql已经解压过,请手动删除"
        exit

fi
wait
cd $mysql_pre_dir
ln -sf  ${mysql_install_version}    mysql
log "create soft link for mysql"

echo -e "export PATH=$PATH:${mysql_dir}/bin\nexport MYSQL_UNIX_PORT=/home/mysql/run/mysql.sock" > /etc/profile.d/mysql$port.sh
log "export PATH env "

mkdir -p ${mysql_dir}/{log,etc,run,data,binlogs}
chown -R mysql.mysql ${mysql_dir}/{data,binlogs,log,etc,run}
log "chown mysql privileges for directory"

rm -f /etc/my.cnf

cat > ${mysql_dir}/etc/my.cnf <<EOF
[client]
port = $port
socket = $mysql_pre_dir/mysql/run/mysql.sock

 

[mysqld]
port = $port
socket = $mysql_pre_dir/mysql/run/mysql.sock
pid_file = $mysql_pre_dir/mysql/run/mysql.pid
datadir = $mysql_pre_dir/mysql/data
basedir = $mysql_pre_dir/mysql
default_storage_engine = InnoDB
max_allowed_packet = 512M
max_connections = 2048
open_files_limit = 65535

skip-name-resolve
lower_case_table_names=1

character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'


innodb_buffer_pool_size = 102M
#innodb_buffer_pool_size = 1024M  实际上面是测试有时候用一下.
innodb_log_file_size = 208M
#innodb_log_file_size = 2048M
innodb_file_per_table = 1
innodb_flush_log_at_trx_commit = 0


key_buffer_size = 64M

log-error = $mysql_pre_dir/mysql/log/mysql_error.log
log-bin = $mysql_pre_dir/mysql/binlogs/mysql-bin
slow_query_log = 1
slow_query_log_file = $mysql_pre_dir/mysql/log/mysql_slow_query.log
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
$mysql_pre_dir/mysql/bin/mysqld --defaults-file=$mysql_pre_dir/mysql/etc/my.cnf --initialize-insecure --user=mysql --basedir=$mysql_pre_dir/mysql --datadir=$mysql_pre_dir/mysql/data
echo "$(date +%F_%T)"
log "init mysql data"

cd /usr/lib/systemd/system
cat > mysqld$port.service<<EOF
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

#Type=forking  #开启后无法退出

PIDFile=$mysql_pre_dir/mysql/run/mysqld.pid

# Disable service start and stop timeout logic of systemd for mysqld service.
TimeoutSec=0

# Execute pre and post scripts as root
PermissionsStartOnly=true

# Needed to create system tables
#ExecStartPre=/usr/bin/mysqld_pre_systemd

# Start main service
ExecStart=$mysql_pre_dir/mysql/bin/mysqld  --defaults-file=$mysql_pre_dir/mysql/etc/my.cnf

# Use this to switch malloc implementation
EnvironmentFile=-/etc/sysconfig/mysql

# Sets open_files_limit
LimitNOFILE = 65535

Restart=on-failure

RestartPreventExitStatus=1

PrivateTmp=false
EOF

log "mysql.service file create "



systemctl daemon-reload
systemctl enable mysqld$port.service
systemctl is-enabled mysqld$port
systemctl start mysqld$port.service 
log "mysql start"


#yum install expect -y 
#log "install expect"


$mysql_pre_dir/mysql/bin/mysql  -S $mysql_pre_dir/mysql/run/mysql.sock  -e " ALTER USER USER() IDENTIFIED BY '123456';"


#mysqladmin -uroot password "$root_mysql_passwd"
echo  -e  "\033[1;31m请执行以下命令,以加载环境变量:\033[0m exec bash \r\n\033[1;31m连接数据库请使用:\033[0m mysql -uroot -p123456 \r\n\033[1;31m登陆后修改密码:\033[0mALTER USER USER() IDENTIFIED BY '123456';"

