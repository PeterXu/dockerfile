#!/usr/bin/env bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- "supervisord" "$@"
fi

if [ "$1" = 'supervisord' ]; then
    #set -- bash
    echo
fi

exec "$@"
