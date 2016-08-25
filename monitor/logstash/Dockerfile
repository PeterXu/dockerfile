FROM lark.io/logstash:lts

RUN echo "deb http://mirrors.aliyun.com/debian jessie main" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian jessie-updates main" >>/etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d/

RUN apt-get update
RUN apt-get install -y net-tools vim
RUN apt-get clean


ADD files/mysql-connector-java-5.1.35.jar /opt/logstash/lib/mysql-connector-java-5.1.35.jar
ADD files/logstash-agent.conf /etc/logstash.d/logstash-agent.conf
ADD files/logstash-broker.conf /etc/logstash.d/logstash-broker.conf
ADD misc /etc/logstash.d/misc
RUN chown logstash /var/log/logstash

ADD docker-entrypoint.sh /docker-entrypoint.sh

