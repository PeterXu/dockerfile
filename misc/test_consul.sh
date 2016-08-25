CONSUL="localhost"

do_test1() 
{
    echo
    echo "[step1] set key/value"
    curl -X GET http://$CONSUL:8500/v1/kv/?recurse
    echo

    echo
    echo "[step1] set key/value"
    DATA="zenvv"
    curl -X PUT -d "$DATA" http://$CONSUL:8500/v1/kv/service/uskee/org
    echo

    echo
    echo "[step2] get key/value"
    curl -X GET http://$CONSUL:8500/v1/kv/service/uskee/org 
    echo

    echo
    echo "[step3] query consul nodes"
    curl -X GET http://$CONSUL:8500/v1/catalog/nodes
    echo
    #[{"Node":"consul_node1","Address":"172.17.0.2"}]

    echo
    echo "[step4] dig node and services"
    #format: TAG.NAME.node.consul
    #format: TAG.NAME.service.consul
    Node="consul_node1"
    Service="consul"
    dig ${Node}.node.consul
    dig ${Service}.service.consul
    echo

    # catalog api
    # register/deregister one node/service/checks.
    catalogs="/v1/catalog/register /v1/catalog/deregister"
    catalogs="/v1/catalog/datacenters /v1/catalog/nodes /v1/catalog/node/<node>"
    catalogs="/v1/catalog/services /v1/catalog/service/<service>"
}

do_test2() 
{
    # register a service by service definition or HTTP api
    cat <<EOF > /tmp/web.json
{
    "datacenter": "dc1",
    "node": "consul_node1",
    "address" : "172.17.0.2",
    "service":
    {
        "id": "webid",
        "name": "web",
        "service": "web",
        "tags": ["master"],
        "address": "192.168.175.131",
        "port": 80
    }
}
EOF
    DATA=$(cat /tmp/web.json)
    curl -X PUT -d "$DATA" http://$CONSUL:8500/v1/catalog/register
    echo
}

do_test2

