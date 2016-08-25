FROM lark.io/tomcat:lts
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


## update apt-get repo
ADD sources.list /etc/apt/
RUN apt-get update
RUN apt-get install -y net-tools vim 
RUN apt-get clean


## config
ADD files/daemon.sh /usr/local/tomcat/bin/
ADD files/catalina.sh /usr/local/tomcat/bin/
ADD files/server.xml /usr/local/tomcat/conf/
ADD files/web.xml /usr/local/tomcat/conf/
ADD files/logging.properties /usr/local/tomcat/conf/

ADD files/jce_policy-8.zip /root
RUN unzip /root/jce_policy-8.zip -d /tmp
RUN cp -f /tmp/UnlimitedJCEPolicyJDK8/*.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/
RUN rm -rf /tmp/UnlimitedJCEPolicyJDK8
#RUN rm -rf /usr/local/tomcat/webapps/*

EXPOSE 8005 8009 8080
VOLUME ["/usr/local/tomcat/logs"]
