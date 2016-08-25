#!/bin/bash

cname=tmp_swarm_`date +%s`
docker run -d -it --name=${cname} lark.io/swarm:lts 
docker cp ${cname}:/swarm . 
docker stop ${cname}
docker rm ${cname}

exit 0
