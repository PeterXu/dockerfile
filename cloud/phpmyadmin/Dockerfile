FROM lark.io/phpmyadmin:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


ADD docker-entrypoint.sh /entrypoint.sh

## running
EXPOSE 9090
ENTRYPOINT ["/entrypoint.sh"]
CMD ["php"]
