FROM lark.io/nginx:lts

RUN mv /usr/sbin/nginx /usr/sbin/nginx.old
COPY nginx /usr/sbin/nginx
RUN mv /etc/nginx /etc/nginx.old
COPY files/nginx /etc/nginx
