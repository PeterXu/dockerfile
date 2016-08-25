FROM lark.io/gitlab:latest

ADD sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y net-tools vim
RUN apt-get clean

ADD entrypoint.sh /sbin/entrypoint.sh
