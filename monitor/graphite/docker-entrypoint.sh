#!/usr/bin/env bash
set -e

# if command starts with an option, prepend nginx
if [ "${1:0:1}" = '-' ]; then
	set -- "supervisord" "$@"
fi

cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

if [ "$1" = '/usr/bin/supervisord' ]; then
    if [ ! -f /graphite.init ]; then
        graphite="/opt/graphite"
        cp -f $graphite/conf/carbon.conf{.example,}
        cp -f $graphite/conf/storage-schemas.conf{.example,}
        cp -f $graphite/conf/graphite.wsgi{.example,}

        #cp $graphite/examples/example-graphite-vhost.conf /etc/apache2/sites-available/graphite-vhost.conf
        rm -f /etc/apache2/sites-enabled/000-default.conf
        ln -sf /etc/apache2/{sites-available,sites-enabled}/graphite-vhost.conf

        cd /opt/graphite/webapp/graphite
        cp -f /opt/graphite/webapp/graphite/local_settings.py{.example,}
        python manage.py syncdb --noinput
        #python manage.py createsuperuser  --noinput --username=root --email="peter@uskee.org"
        #TIME_ZONE = 'UTC'
        sed -in "s#'UTC'#'Asia/Shanghai'#" /opt/graphite/webapp/graphite/settings.py
        rm -f /opt/graphite/webapp/graphite/settings.pyn
        touch /graphite.init
    fi
    chown -R www-data:www-data /opt/graphite/storage
    service apache2 restart || echo
fi

exec "$@"
