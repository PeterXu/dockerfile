#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- tomcat "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

mkdir -p /etc/camp
conf="/etc/camp/config.properties"
[ ! -f $conf ] && cp -f /root/config.properties $conf


if [ "$1" = 'tomcat' ]; then
    [ "$dbHost" != "" ] && sed -in "s#mysql://db#mysql://$dbHost#" $conf
    [ "$dbPort" != "" ] && sed -in "s#3306#$dbPort#" $conf
    rm -f ${conf}n

    #set catalina.sh jpda run
    set catalina.sh run
fi

exec "$@"
