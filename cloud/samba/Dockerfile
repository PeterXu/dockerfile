FROM lark.io/samba:latest
MAINTAINER Peter <peter@uskee.org>
LABEL "org.uskee.vendor"="ZENVV"


RUN mv /etc/samba/smb.conf /etc/samba/smb.conf.old
ADD files/smb.conf /etc/samba/

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["samba"]
