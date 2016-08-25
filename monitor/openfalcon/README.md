open-falcon
===========


## base modules

redis
mysql

## env

export HOME=/opt
export WORKSPACE=$HOME/openfalcon
mkdir -p $WORKSPACE
cd $WORKSPACE


## init mysql

```
db_host=localhost
db_user=root
db_pass=pass

sql_root="scripts/db_schema"
schemas="graph-db-schema.sql dashboard-db-schema.sql portal-db-schema.sql links-db-schema.sql uic-db-schema.sql"
for sql in $schemas; do
    mysql -h $db_host -u $db_user --password="$db_pass" < $sql_root/$sql
done
```

