#!/bin/bash

USER="root"

MASTER_USER="backup"
MASTER_PASS="backup"
MASTER_IP="192.168.175.131"
MASTER_FILE="mysql-bin.000003"

do_master() {
    local cmd
    cmd="GRANT REPLICATION SLAVE ON *.* TO '$MASTER_USER'@'%' IDENTIFIED BY '$MASTER_PASS';"
    mysql -u $USER -h 127.0.0.1 -p -e "$cmd"
    cmd="flush privileges; show master status;"
    mysql -u $USER -h 127.0.0.1 -p -e "$cmd"
}


do_slave() {
    local cmd
    cmd="CHANGE MASTER TO MASTER_HOST='$MASTER_IP',"
    cmd="$cmd MASTER_USER='$MASTER_USER', MASTER_PASSWORD='$MASTER_PASS',"
    cmd="$cmd MASTER_LOG_FILE='$MASTER_FILE', MASTER_LOG_POS=0;"
    mysql -u $USER -h 127.0.0.1 -p -e "$cmd"

    #mysql> SHOW SLAVE STATUS;
    #mysql> START SLAVE;
    #mysql> show processlist;
}

action="$1"
if [ "$action" = "master" -o "$action" = "slave" ]; then
    do_$action
else
    echo "usage: $0 master|slave"
fi

exit 0
