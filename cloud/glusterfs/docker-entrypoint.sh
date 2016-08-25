#!/bin/bash
set -e

# if command starts with an option
if [ "${1:0:1}" = '-' ]; then
	set -- glusterd "$@"
fi

if [ "$1" = 'data' ]; then
    mkdir -p /mnt/brick1/data
    mkdir -p /mnt/brick2/data
    set -- bash -l
elif [ "$1" = "/usr/bin/supervisord" ]; then
    mkdir -p /root/.ssh
    cp -f /root/config /root/.ssh/
    [ -f /root/.rssh/authorized_keys ] && cp -f /root/.rssh/authorized_keys /root/.ssh/
    [ -f /root/.rssh/id_rsa ] && cp -f /root/.rssh/id_rsa /root/.ssh/

    #service ssh start
    service rpcbind start
fi

exec "$@"
