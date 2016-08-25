FROM lark.io/ubuntu:latest
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y apt-utils net-tools
RUN apt-get install -y supervisor
RUN apt-get install -y coturn
RUN apt-get clean


ADD files/turnserver.conf /etc/turnserver.conf
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


ADD docker-entrypoint.sh /entrypoint.sh
EXPOSE 3478 3479 5766
VOLUME ["/var/log/supervisor"]
VOLUME ["/var/log/coturn"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]

