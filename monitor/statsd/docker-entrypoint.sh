#!/usr/bin/env bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- "supervisord" "$@"
fi

if [ "$graphiteHost" != "" ]; then
    sed -in "s/mon.io/$graphiteHost/" /statsd/config.js
    rm -f /statsd/config.jsn
fi

[ "$flushInterval" = "" ] && flushInterval=10000
sed -in "s/interval10s/$flushInterval/" /statsd/config.js
rm -f /statsd/config.jsn

cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

if [ "$1" = '/usr/bin/supervisord' ]; then
    #set -- bash -l
    echo
fi

exec "$@"
