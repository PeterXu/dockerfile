FROM lark.io/kibana:lts

RUN echo "deb http://mirrors.aliyun.com/debian jessie main" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian jessie-updates main" >> /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d/*

RUN apt-get update
RUN apt-get install -y vim net-tools
RUN apt-get clean


RUN rm -rf /opt/kibana
ADD kibi-0.3.2-linux-x64 /opt/kibana

#ENV MAP_URI0 "https://otile{s}-s.mqcdn.com/tiles/1.0.0/map/{z}/{x}/{y}.jpeg"
#ENV MAP_URI1 "http://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=1&style=7&x={x}&y={y}&z={z}"
#RUN sed -in "s#${MAP_URI0}#${MAP_URI1}#" /opt/kibana/optimize/bundles/kibana.bundle.js
ADD files/kibana.bundle.js /opt/kibana/optimize/bundles/kibana.bundle.js
RUN chown kibana:kibana -R /opt/kibana


ADD files/docker-entrypoint.sh /docker-entrypoint.sh
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["kibi"]
