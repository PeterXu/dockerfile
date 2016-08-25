#!/bin/bash


[ "$httpPort" ] && sed -i "s#^Listen 80#Listen $httpPort#" /etc/apache2/apache2.conf

exec "$@"
