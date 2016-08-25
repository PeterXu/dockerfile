#!/bin/bash

db="sbtest"
user="sbtest"
pass="sbtest"
host="127.0.0.1"
port="3306"

# mysql auth
auth="--db-driver=mysql --mysql-db=$db --mysql-host=$host --mysql-port=$port"
auth="$auth --mysql-user=$user --mysql-password=$pass"


# parameters
threads=15
requests=10000
base="--num-threads=$threads --max-requests=$requests"

prepare() {
    echo
    #
    # create database sbtest;
    # grant all on sbtest.* to sbtest@'%' identified by 'sbtest';
    # CREATE TABLE `sbtest` (`id` int(10) unsigned NOT NULL AUTO_INCREMENT, `k` int(10) unsigned NOT NULL DEFAULT '0', `c` char(120) NOT NULL DEFAULT '', `pad` char(60) NOT NULL DEFAULT '',PRIMARY KEY (`id`),KEY `k` (`k`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;
}

test1() {
    table="1000000"
    opts="--test=oltp --mysql-table-engine=innodb --oltp-table-size=$table"
    cmd="sysbench $base $opts $auth run"
    echo "$cmd" && eval "$cmd"
    echo
}


test2() {
    table="1000000"
    opts="--test=oltp --mysql-table-engine=innodb --oltp-table-size=$table --oltp-test-mode=complex"
    cmd="sysbench $base $opts $auth run"
    echo "$cmd" && eval "$cmd"
    echo
}

test1

