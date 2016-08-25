#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- apache2 "$@"
fi

[ "$LOG_PATH" ] && mkdir -p $LOG_PATH
[ "$UPLOAD_PATH" ] && mkdir -p $UPLOAD_PATH


if [ "$1" = "apache2" ]; then
    apache2ctl start
fi

set -- bash -l

exec "$@"
