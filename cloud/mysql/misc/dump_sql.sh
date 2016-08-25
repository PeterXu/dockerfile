#!/usr/bin/env bash


# local
db="soccerdojo"
dbuser="soccerdojo"
dbport=3306
dbfile="/tmp/${db}-$RANDOM.sql"

dbopts="-p -P $dbport -u $dbuser -h 127.0.0.1"

# remote
ruser="peter"
rhost="192.168.175.147"
rport="22"
raddr=$ruser@$rhost


dump_data() {
    mysqldump $dbopts --databases $db > $dbfile
}

import_data() {
    [ ! -f $dbfile ] && return 1
    mysql $dbopts --database $db < $dbfile
}

auto_data() {
    mysqldump $dbopts --databases $db | ssh -p $rport $raddr mysql
    #mysqldump --databases $db | mysql -p $rport -h $rhost
    #mysqldump --databases $db | mysql --compress -p $rport -h $rhost $db 
}

