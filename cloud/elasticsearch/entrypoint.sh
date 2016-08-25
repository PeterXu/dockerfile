#!/bin/bash

cpath="/usr/share/elasticsearch/config"
conf="$cpath/elasticsearch.yml"

init_config() {
    cp -f /root/etc/elasticsearch.yml $cpath
    cp -f /root/etc/logging.yml $cpath
    chown elasticsearch:elasticsearch /usr/share/elasticsearch/logs
    return 0
}

set_config() {
    if [ "$clusterName" ]; then
        sed -in "s#^cluster.name: .*#cluster.name: $clusterName#" $conf
    fi

    if [ "$networkBindhost" ]; then
        sed -in "s#^network.bind_host: .*#network.bind_host: $networkBindhost#" $conf
    fi

    if [ "$networkPublishhost" ]; then
        sed -in "s#^network.publish_host: .*#network.publish_host: $networkPublishhost#" $conf
    fi

    if [ "$clusterHosts" ]; then
        local key="discovery.zen.ping.unicast.hosts"
        sed -in "s/^#$key: .*/$key: $clusterHosts/" $conf
    fi

    rm -f ${conf}n
}

set_readonlyrest() {
    [ "$use_readonlyrest" != "yes" ] && return
    cat $conf | grep readonlyrest >/dev/null 2>&1 && return
    local tconf="/root/etc/readonlyrest.yml"
    [ ! -f $tconf ] && return
    cat $tconf >>$conf 
    return 0
}


init_config
set_config
set_readonlyrest


XmsMem=${XmsMem:-4g}
XmxMem=${XmxMem:-16g}
export ES_JAVA_OPTS="
-Xms${XmsMem} -Xmx${XmxMem}
-XX:+AggressiveOpts
-XX:+UseBiasedLocking
-XX:+DisableExplicitGC
-XX:+UseConcMarkSweepGC
-XX:+UseParNewGC
-XX:+CMSParallelRemarkEnabled
-XX:LargePageSizeInBytes=128m
-XX:+UseFastAccessorMethods
-XX:+UseCMSInitiatingOccupancyOnly 
-Djava.awt.headless=true
-Djava.security.egd=file:/dev/./urandom
"

# redirect to origin entrypoing
source /docker-entrypoint.sh
