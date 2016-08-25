FROM lark.io/tomcat:stable


## config
RUN sed -in "s#tomcatapp#camp#g" /usr/local/tomcat/conf/server.xml

ADD files/config.properties /root/config.properties
ADD .camp/target/camp.war /usr/local/tomcat/webapps/
#ADD .camp/target/camp /usr/local/tomcat/webapps/


ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["tomcat"]

