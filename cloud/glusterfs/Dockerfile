FROM lark.io/gluster:lts
MAINTAINER Peter <peter@uskee.org>


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y net-tools vim
RUN apt-get install -y supervisor
RUN apt-get install -y rpcbind nfs-common rstatd
RUN apt-get install -y openssh-client
RUN apt-get install -y openssh-server
RUN apt-get clean


## work script
WORKDIR /root
ADD files/config /root
RUN sed -i "s#PermitRootLogin without-password#PermitRootLogin yes#" /etc/ssh/sshd_config

ADD docker-entrypoint.sh /entrypoint.sh
ADD files/glusterdctl /usr/sbin

## start program and args
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 24007 24008
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
