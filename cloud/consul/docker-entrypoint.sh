#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- consul "$@"
fi

#cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

if [ "$1" = "consul" ]; then
    conf="/config"
    mkdir -p $conf /ui

    shift && opts="$@"
    if [ "$consulRole" = "server" ]; then
        cp -f /root/agent.json $conf
        cp -f /root/server.json $conf
    elif [ "$consulRole" = "agent" ]; then
        cp -f /root/agent.json $conf
    fi
    
    set -- /bin/consul $opts -config-dir=$conf
fi

exec "$@"
