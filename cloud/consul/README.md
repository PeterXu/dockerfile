## create service 'simple'

```
curl -XPUT dns.io:8500/v1/agent/service/register \
    -d '{
    "ID": "simple_instance_1",
    "Name":"simple",
    "Port": 8000, 
    "tags": ["tag"]
}'
```

## check

```
dig @dns.io -p 8600 simple.service.consul
dig @dns.io -p 8600 SRV simple.service.consul
```


## start
nginx.ctmpl:
    {{range $tag, $services := service "simple" | byTag}}
    {{range $services}}server {{.Address}}:{{.Port}};{{end}}
    {{else}}server 127.0.0.1 down;{{end}}

```
consul-template -consul dns.io:8500 -retry 30s -template "files/nginx.ctmpl:nginx.ctmpl.conf"
consul-template -consul dns.io:8500 -retry 30s -template "files/nginx.ctmpl:nginx.ctmpl.conf:nginx -s reload"
```


## update service

```
curl -XPUT dns.io:8500/v1/agent/service/register \
    -d '{
    "ID": "id1",
    "Name":"simple",
    "Address": "dns.io",
    "Port": 8080, 
    "tags": ["tag"]
}'

curl -XPUT dns.io:8500/v1/agent/service/register -d @misc/service1.json
curl -XPUT dns.io:8500/v1/agent/service/register -d @misc/service2.json
curl -XGET dns.io:8500/v1/agent/services
curl -XPUT dns.io:8500/v1/agent/service/deregister/id
```

