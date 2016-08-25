FROM lark.io/mysql:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y apt-utils net-tools vim
RUN apt-get clean

ADD files/my.cnf /etc/mysql/
ADD files/master.cnf /root/
ADD files/slave.cnf /root/
ADD docker-entrypoint.sh /entrypoint.sh

## running
EXPOSE 3306
VOLUME ["/var/lib/mysql"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
