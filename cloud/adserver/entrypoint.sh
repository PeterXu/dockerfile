#!/bin/bash


if [ ! -f /var/www/html/var/default.conf.php ]; then
    cp -rf /root/adserver/* /var/www/html/
    chown www-data:www-data -R /var/www/html/*
fi

[ "$httpPort" ] && sed -i "s#^Listen 80#Listen $httpPort#" /etc/apache2/apache2.conf

exec "$@"
