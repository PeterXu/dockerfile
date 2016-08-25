FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y net-tools vim
RUN apt-get install -y keepalived
RUN apt-get install -y curl
RUN apt-get clean

ADD files/notify.sh /root
ADD files/check_app.sh /root
ADD files/keepalived.conf /root

## start
ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["keepalived", "-n"]

