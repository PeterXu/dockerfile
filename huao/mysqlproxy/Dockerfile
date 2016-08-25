FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y net-tools vim
RUN apt-get install -y mysql-proxy
RUN apt-get clean

RUN sed -in 's#ENABLED="false"#ENABLED="true"#' /etc/default/mysql-proxy
RUN rm -f /etc/default/mysql-proxyn

## start
ADD docker-entrypoint.sh /entrypoint.sh
EXPOSE 3306 4040 4041
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysql-proxy"]

