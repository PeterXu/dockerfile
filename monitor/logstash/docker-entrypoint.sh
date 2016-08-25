#!/bin/bash

set -e

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

conf="/etc/logstash" && mkdir -p $conf
cp -rf /etc/logstash.d/misc $conf

files=$(ls /etc/logstash.d/*.conf 2>/dev/null)
for src in $files; do
    dst="$conf/$(basename $src)"
    [ ! -f "$dst" ] && cp -f $src $dst
done

export LS_JAVA_OPTS="
-Xms512m -Xmx2g
-XX:+AggressiveOpts
-XX:+UseBiasedLocking
-XX:+DisableExplicitGC
-XX:+UseConcMarkSweepGC
-XX:+UseParNewGC
-XX:+CMSParallelRemarkEnabled
-XX:LargePageSizeInBytes=128m
-XX:+UseFastAccessorMethods
-XX:+UseCMSInitiatingOccupancyOnly 
-Djava.awt.headless=true
-Djava.security.egd=file:/dev/./urandom
"

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	set -- gosu logstash "$@" -l /var/log/logstash/logstash.log
    chown logstash /var/log/logstash
fi

exec "$@"
