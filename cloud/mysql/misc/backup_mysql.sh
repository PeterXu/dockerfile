#!/bin/bash

db_user="root"
db_pass="pass"
db_name="mysql"

# storage path
ddir="/mnt/backup/mysql"
dfile="$ddir/${db_name}_$(date +%Y-%m-%d-%H-%M-%S).sql"

# mysqldump options
#opts="--single-transaction --skip-lock-tables --compact --skip-opt --quick --no-create-info --skip-extended-insert"
opts="--single-transaction --skip-lock-tables --compact --skip-opt --quick --skip-extended-insert"

mysqldump $opts -u ${db_user} -p${db_pass} -h 127.0.0.1 --databases ${db_name} > "$dfile"
chmod -w "$dfile"

exit 0
