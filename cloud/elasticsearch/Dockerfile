FROM lark.io/elasticsearch:lts

RUN echo "deb http://mirrors.aliyun.com/debian jessie main" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian jessie-updates main" >> /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d/*

RUN apt-get update
RUN apt-get install -y vim net-tools
RUN apt-get clean


## install plugins
WORKDIR /usr/share/elasticsearch

##
## for built-in plugins

# for javascript plugin
RUN ./bin/plugin install -b lang-javascript

# for icu and smartcn chinese
RUN ./bin/plugin install -b analysis-icu
RUN ./bin/plugin install -b analysis-smartcn


##
## for 3rd-patry plugins

# for web
RUN ./bin/plugin install -b mobz/elasticsearch-head
RUN ./bin/plugin install -b royrusso/elasticsearch-HQ
RUN ./bin/plugin install -b lmenezes/elasticsearch-kopf

# for mapper
RUN ./bin/plugin install -b mapper-attachments
RUN ./bin/plugin install -b mapper-size
RUN ./bin/plugin install -b mapper-murmur3

# for access control
RUN ./bin/plugin install https://github.com/sscarduzio/elasticsearch-readonlyrest-plugin/raw/master/download/elasticsearch-readonlyrest-v1.7_es-v2.2.1.zip

# for siren-join
COPY files/siren-join-2.2.1.zip /root
RUN ./bin/plugin install -b file:///root/siren-join-2.2.1.zip 

# for sql
COPY files/elasticsearch-sql-2.2.1.zip /root
RUN ./bin/plugin install -b file:///root/elasticsearch-sql-2.2.1.zip


##
## for config
RUN rm -rf /etc/elasticsearch
ADD files/etc /root/etc
RUN chown elasticsearch:elasticsearch /usr/share/elasticsearch/logs


ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["elasticsearch"]
