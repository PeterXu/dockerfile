#!/usr/bin/env bash
set -e

# if command starts with an option
if [ "${1:0:1}" = '-' ]; then
	set -- "supervisord" "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

if [ "$1" = '/usr/bin/supervisord' ]; then
    cat /etc/hosts | grep -v "::[0-9]" | tee /etc/hosts >/dev/null
    echo
fi

exec "$@"
