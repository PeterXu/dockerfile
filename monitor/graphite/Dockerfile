FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y python-django python-twisted python-django-tagging
RUN apt-get install -y python-cairo python-pip 
RUN apt-get install -y apache2 libapache2-mod-wsgi 
#RUN apt-get install -y graphite-carbo graphite-web
RUN apt-get install -y supervisor
RUN apt-get clean


ADD files/requirements.txt /root/requirements.txt
ADD pip.conf /root/.pip/pip.conf
RUN pip install -i http://mirrors.aliyun.com/pypi/simple -r /root/requirements.txt
RUN pip install -i http://mirrors.aliyun.com/pypi/simple -U pip


ADD files/graphite-vhost.conf /etc/apache2/sites-available/graphite-vhost.conf
ADD files/apache2.conf /etc/apache2/apache2.conf
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD docker-entrypoint.sh /entrypoint.sh
EXPOSE 80 2003 2004 7002
VOLUME ["/opt/graphite/storage/whisper"]
VOLUME ["/var/log/supervisor"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord"]

