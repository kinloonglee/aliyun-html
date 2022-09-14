#!/bin/bash
userip=$1
password=$2
   expect <<-EOF
   set timeout 1                 
   spawn ssh -p52113 root@$userip
   expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$password\r" }
    }
   expect  "*$ " {   send "df -h\r" }
   expect  "*$ " {   send "free -m\r"  }
   #interact       
   expect eof
EOF
