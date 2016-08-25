#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- router "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


conf="/etc/mysqlrouter/mysqlrouter.ini"
if [ -f "$conf" ]; then
    #default="192.168.10.1,192.168.10.2"
    default="$mysqlHosts"
    if [ "$default" = "" ]; then
        [ "$TAG" = "" ] && echo "[ERROR] no env: TAG" && exit 1
        envName="mysqlHosts_${TAG}"
        default=$(eval echo \${${envName}})
        [ "${default}" = "" ] && echo "[ERROR] no env: $envName" && exit 1
    fi
    echo "[INFO] mysql hosts: $default"

    sed -i "s#destinations =.*#destinations = $default#" $conf
fi


if [ "$1" = 'start' ]; then
    sleep 1
    set -- bash -l
fi

exec "$@"
