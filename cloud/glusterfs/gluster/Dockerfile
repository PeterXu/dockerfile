FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>

## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update

## work script
ADD .glusterfs /root/glusterfs
WORKDIR /root/glusterfs
RUN bash run_check.sh
RUN apt-get clean
RUN bash run_glusterfs.sh
RUN make && make install
WORKDIR /root
RUN rm -rf /root/glusterfs


## start program and args
EXPOSE 24007 24008
VOLUME ["/var/lib/glusterfs"]
CMD ["glusterd"]
