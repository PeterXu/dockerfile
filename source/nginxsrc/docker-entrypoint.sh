#!/bin/bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- nginx "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

if [ "$1" = 'nginx' ]; then
    cfg="/etc/nginx/sites-available/nginx-src.conf"
    dst="/etc/nginx/sites-enabled/nginx-src.conf"
    [ ! -f "$dst" ] && cp -f $cfg $dst

    [ "$aptsrc_host" != "" ] && sed -in "s/aptsrc-host/$aptsrc_host/" $dst
    [ "$registry_host" != "" ] && sed -in "s/registry-host/$registry_host/" $dst
    [ "$mvnsrc_host" != "" ] && sed -in "s/mvnsrc-host/$mvnsrc_host/" $dst
    rm -f ${dst}n
    echo
fi

exec "$@"
