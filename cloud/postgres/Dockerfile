FROM lark.io/postgres:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"

## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y net-tools vim
RUN apt-get clean


## running
ADD docker-entrypoint.sh /docker-entrypoint.sh
VOLUME ["/var/log/postgresql"]
