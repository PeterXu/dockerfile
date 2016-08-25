#!/usr/bin/env bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- "supervisord" "$@"
fi

cfg="/etc/supervisor/conf.d/supervisord.conf"
if [ "$statsdHost" != "" ]; then
    sed -in "s/mon.io/$statsdHost/" $cfg
    rm -f ${cfg}n
fi

if [ "$procPrefix" != "" ]; then
    sed -in "s#/host/#$procPrefix#" $cfg
    rm -f ${cfg}n
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

if [ "$1" = '/usr/bin/supervisord' ]; then
    #set -- bash -l
    echo
fi

exec "$@"
