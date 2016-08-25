docker 
======

## API for registry
GET /v2/_catalog
GET /v2/(name)/manifests/(tag)
GET /v2/(name)/tags/list

## API for docker daemon
GET /info
GET /version
GET /networks
GET /volumes
GET /events
GET /images/json
GET /images/(name)/json
GET /containers/json
GET /containers/(id)/stats
GET /containers/(name)/json



## Architecture for docker

*) consul/etcd + dnsmasq for service discovery
*) ldap for auth service
*) docker daemon
*) auth for all docker daemons
*) swarm agent for all docker daemons

## network

a. bridge network(single-host)
```
docker network ls
docker network inspect bridge
docker network inspect isolated_nw
docker network create --driver bridge isolated_nw
docker run --net=<NETWORK> -d -it image 
```

b. overlay network(multi-host)
This support is accomplished with the help of libnetwork, 
    a built-in VXLAN-based overlay network driver, and Docker’s libkv library.
Currently, Docker’s libkv supports Consul, Etcd, and ZooKeeper. 


## swarm 

docker cmd
```
docker -H :3375 ps 

# run on which name is idc_node_0*.
docker -H :3375 run -e constraint:node=="idc_node_0*" ..

# run on which storage is disk/ssd
docker -H :3375 run -e constraint:storage=="disk" ..
docker -H :3375 run -e constraint:storage=="ssd" ..

# run on which has container of yaml_swarm_1/cid
docker -H :3375 run -e affinity:container=="yaml_swarm_1|cid" ..

# run on which has image of nginx
docker -H :3375 run -e affinity:image=="nginx" ..

# by label
docker -H :3375 run --label com.example.type=frontend ...
docker -H :3375 ps --filter "label=com.example.type=frontend"
docker -H :3375 run -d -e affinity:com.example.type==frontend nginx
```

docker-compose
```
version: "2"
services:
  foo:
  image: foo
  volumes_from: ["bar"]
  network_mode: "service:baz"
  environment:
    - "constraint:node==node-1"

bar:
  image: bar
  environment:
    - "constraint:node==node-1"
```

