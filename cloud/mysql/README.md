
master-slave
=============

## master's my.cnf:

>server_id          = 1
>log_bin            = mysql-bin

mysql> GRANT REPLICATION SLAVE,RELOAD,SUPER ON *.* TO 'backup'@'%' 
    IDENTIFIED BY 'backup';
mysql> GRANT SELECT ON dbname.* TO 'backup'@'%';
mysql> flush privileges;
mysql> show master status;


## slave's my.cnf:
>server_id          = 2
>log_bin            = mysql-bin
>relay_log          = mysql-relay-bin
>log_slave_updates  = 1
>read_only          = 1

mysql> CHANGE MASTER TO MASTER_HOST='master_ip', 
    MASTER_USER='backup', MASTER_PASSWORD='backup',
    MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=0;
mysql> SHOW SLAVE STATUS;
mysql> START SLAVE;
mysql> show processlist;


mysql ndbcluster
================

## default 200
set global max_connections = 1000; 
## default 128k, for nested queries
set global read_buffer_size = 1048576;

## default 30/60 sec
net_read_timeout = 30
net_write_timeout = 60
## default 256k, for ORDER BY performance and set by session
read_rnd_buffer_size = 256k

## default 24m
ndb_batch_size = 24m;
## default 64k
ndb_blob_read_batch_bytes = 64k
ndb_blob_write_batch_bytes = 64k
## default 1024
ndb_autoincrement_prefetch_sz = 1024
## default 0
ndb_cache_check_time = 0
## default 1
ndb_extra_logging = 1



mysql data_free
===============

## check table status
show table status like 'table_name';

## list all data-free tables
select table_schema,table_name,data_free,engine \
from information_schema.tables \
where table_schema not in ('information_schema','mysql') and data_free > 100*1024*1024;

## optimize myisam
optimize table table_name;

## optimize innodb
alter table table_name engine=InnoDB;



mysql binlog
============

 server_id = 10
 log_bin = mysql-bin
 binlog_format = ROW # STATEMENT/MIXED 


