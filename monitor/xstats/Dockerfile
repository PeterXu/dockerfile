FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y supervisor
RUN apt-get clean

ADD system /usr/bin/system

ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD docker-entrypoint.sh /entrypoint.sh
VOLUME ["/var/log/supervisor"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
