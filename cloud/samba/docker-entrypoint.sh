#!/bin/bash
set -e

cmd=""
if [ "${1:0:1}" = '-' ]; then
    cmd="samba"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

if [ "$cmd" = "samba" ]; then
    /usr/bin/samba.sh $@
else
    exec "$@"
fi
