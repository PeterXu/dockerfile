FROM lark.io/php:5.6-apache

RUN echo "deb http://mirrors.aliyun.com/debian jessie main" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian jessie-updates main" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install -y vim net-tools

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# mod mysql/mbstring
RUN docker-php-ext-install mysql
RUN docker-php-ext-install mbstring

# mod curl/gd
RUN apt-get install -y libcurl4-openssl-dev
RUN docker-php-ext-install curl
RUN apt-get install -y libpng-dev
RUN docker-php-ext-install gd
ADD files/php.ini-production /usr/local/etc/php/php.ini

# project
ADD .revive-adserver /root/adserver
RUN mkdir -p /root/adserver/test
ADD files/index.php /root/adserver/test/index.php
RUN chown www-data:www-data -R /root/adserver


ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
