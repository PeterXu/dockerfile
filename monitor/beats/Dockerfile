FROM lark.io/ubuntu:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


RUN sed -in "s#archive.ubuntu.com#mirrors.aliyun.com#g" /etc/apt/sources.list 
RUN rm -f /etc/apt/sources.listn
RUN apt-get update
RUN apt-get install -y monit
RUN apt-get install -y libpcap0.8
RUN apt-get install -y geoip-database
RUN apt-get clean


ADD files/topbeat /usr/bin
ADD files/filebeat /usr/bin
ADD files/packetbeat /usr/bin
ADD conf /root/conf
ADD tmpl /root/tmpl
ADD svc /root/svc
ADD files/GeoLiteCity.dat /usr/share/GeoIP/GeoLiteCity.dat

ADD files/monitrc /etc/monit/

ADD docker-entrypoint.sh /entrypoint.sh
#VOLUME ["/etc/monit/conf.d/"]
#VOLUME ["/etc/beats/"]
ENTRYPOINT ["/entrypoint.sh"]
