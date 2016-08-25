#!/usr/bin/env bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- "monit" "$@"
fi

# for beats conf
rpath="/etc/beats"
if [ ! -f $rpath/zhad ]; then
    mkdir -p $rpath
    touch $rpath/zhad
    chmod -w $rpath/zhad

    cp -f /root/conf/*.yml $rpath
fi

if [ "$1" = 'monit' ]; then
    rpath="/etc/monit/conf.d"
    if [ ! -f $rpath/zhad -a "$BEATS" != "" ]; then
        # for moint conf
        mkdir -p $rpath
        touch $rpath/zhad
        chmod -w $rpath/zhad

        for svc in $BEATS; do
            cp -f /root/svc/${svc} $rpath
        done
    fi
    mkdir -p /var/log/beats
    echo
fi

exec "$@"
