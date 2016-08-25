#!/bin/bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- nginx "$@"
fi

if [ "$1" = 'nginx' ]; then
    root="/var/spool/apt-mirror/mirror"
    sites=$(ls $root)
    for site in $sites; do
        sdirs=$(ls $root/$site)
        for sdir in $sdirs; do
            src="$root/$site/$sdir"
            dst="/usr/share/nginx/html/$sdir"
            [ -d $src -a ! -e $dst ] && ln -s $src $dst
        done
    done
fi

exec "$@"
