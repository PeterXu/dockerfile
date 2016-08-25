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
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
RUN mkdir -p /var/www/html/test
COPY .yyx /var/www/html/
ADD files/index.php /var/www/html/test/
RUN chown www-data:www-data -R /var/www/html


ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
