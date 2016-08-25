#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- mysql-proxy "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

[ "$ADMIN_OPTIONS" ] && OPTIONS="$OPTIONS $ADMIN_OPTIONS"
[ "$PROXY_OPTIONS" ] && OPTIONS="$OPTIONS $PROXY_OPTIONS"
[ "$PROXY_BACKEND_OPTIONS" ] && OPTIONS="$OPTIONS $PROXY_BACKEND_OPTIONS"
[ "$PROXY_BACKEND_RO_OPTIONS" ] && OPTIONS="$OPTIONS $PROXY_BACKEND_RO_OPTIONS"

if [ "$1" = 'mysql-proxy' ]; then
    conf="/etc/default/mysql-proxy"
    [ ${#OPTIONS} -ge 7 ] && sed -in "s#OPTIONS=.*#OPTIONS=\"$OPTIONS\"#" $conf
    rm -f ${cfg}n
    #service mysql-proxy start

    LUA_PATH="/usr/share/mysql-proxy/?.lua"
    PIDFILE="/var/run/mysql-proxy.pid"
    OPTIONS="$OPTIONS --pid-file $PIDFILE"

    echo "mysql-proxy $OPTIONS"
    set mysql-proxy $OPTIONS
    #set bash -l
    echo
fi

exec "$@"
