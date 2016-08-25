FROM lark.io/ubuntu:lts

RUN sed -in "s#archive.ubuntu.com#mirrors.aliyun.com#" /etc/apt/sources.list
RUN rm -f /etc/apt/sources.listn
RUN apt-get update
RUN apt-get install -y vim net-tools
RUN apt-get install -y apache2 libapache2-mod-php5
RUN apt-get install -y php5
RUN apt-get install -y php5-mysql
RUN apt-get install -y php5-pgsql
RUN apt-get clean


ADD files/1.9.14.tar.gz /var/
RUN mv /var/testlink-code-1.9.14 /var/testlink
ADD files/*.php /var/testlink/
RUN mkdir -p /var/testlink/logs
RUN mkdir -p /var/testlink/upload_area


RUN chown www-data:www-data -R /var/testlink
RUN ln -s /var/testlink /var/www/html/testlink
ADD files/php.ini /etc/php5/apache2/

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2"]
