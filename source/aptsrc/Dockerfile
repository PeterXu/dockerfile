FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y vim net-tools libssl1.0.0
RUN apt-get install -y nginx nginx-full
RUN apt-get install -y apt-mirror
RUN apt-get clean

ADD files/default /etc/nginx/sites-enabled/
ADD files/mirror.list /etc/apt/mirror.list

## start
ADD docker-entrypoint.sh /entrypoint.sh
EXPOSE 80 443
VOLUME ["/var/spool/apt-mirror"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

