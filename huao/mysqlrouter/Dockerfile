FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y apt-utils net-tools
RUN apt-get install -y supervisor
RUN apt-get install -y apparmor
RUN apt-get clean

ADD files/mysql-router_2.0.2-1ubuntu14.04_amd64.deb /root
RUN dpkg -i /root/mysql-router_2.0.2-1ubuntu14.04_amd64.deb
RUN rm -f /root/mysql-router_2.0.2-1ubuntu14.04_amd64.deb

#ADD files/mysqlrouter.ini /root/mysqlrouter.ini
ADD files/mysqlrouter.ini /etc/mysqlrouter/mysqlrouter.ini
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## start
ADD docker-entrypoint.sh /entrypoint.sh
EXPOSE 3306
#VOLUME ["/var/log/supervisor"]
#VOLUME ["/var/log/mysqlrouter"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]

