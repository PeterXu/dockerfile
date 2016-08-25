#!/bin/bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- nginx "$@"
fi

if [ "$1" = 'nginx' ]; then
    sleep 1
fi

exec "$@"
