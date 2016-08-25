FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y apt-utils net-tools libssl1.0.0
RUN apt-get install -y nginx nginx-full
RUN apt-get clean

RUN rm -f /etc/nginx/sites-enabled/default
ADD files/nginx-src.conf /etc/nginx/sites-available/nginx-src.conf

## start
ADD docker-entrypoint.sh /entrypoint.sh
VOLUME ["/var/log/nginx"]
EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

