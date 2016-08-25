FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y apt-utils net-tools python-pip libssl1.0.0
RUN apt-get install -y nginx nginx-full
RUN apt-get install -y python-virtualenv python-distribute
RUN apt-get -f install
RUN apt-get autoremove
RUN apt-get clean


## config
# install extra python packages
WORKDIR /root
ADD pip.conf /root/.pip/pip.conf.bak
RUN rm /etc/nginx/sites-enabled/default
ADD files/nginx-pypi.conf /etc/nginx/sites-enabled/nginx-pypi.conf
ADD files/docker-entrypoint.sh /entrypoint.sh
RUN virtualenv bandersnatch

WORKDIR /root/bandersnatch
ADD files/run.sh /root/bandersnatch
RUN bin/pip install -r https://bitbucket.org/pypa/bandersnatch/raw/stable/requirements.txt
#RUN bin/bandersnatch mirror
ADD files/bandersnatch.conf /etc/bandersnatch.conf


## start
WORKDIR /root
EXPOSE 80 443
VOLUME ["/var/lib/pypi"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

