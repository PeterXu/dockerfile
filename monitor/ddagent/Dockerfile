FROM lark.io/docker-dd-agent:stable

ADD sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y net-tools vim

ADD docker-entrypoint.sh /entrypoint.sh

