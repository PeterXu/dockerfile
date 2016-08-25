MAXCONN=4000
CONSUL=localhost

curl -X PUT -d "$MAXCONN" http://$CONSUL:8500/v1/kv/service/haproxy/maxconn


# query
curl -v http://localhost:8500/v1/kv/?recurse
