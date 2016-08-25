FROM lark.io/ubuntu:latest
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y apt-utils net-tools
RUN apt-get install -y supervisor
RUN apt-get install -y stuntman-server
RUN apt-get clean


ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


ADD docker-entrypoint.sh /entrypoint.sh
EXPOSE 3478
VOLUME ["/var/log/supervisor"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]

