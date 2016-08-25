FROM lark.io/ubuntu:lts
MAINTAINER Peter "peter@uskee.org"

# install packages
RUN sed -in "s#archive.ubuntu.com#mirrors.aliyun.com#" /etc/apt/sources.list && rm -f /etc/apt/sources.listn
RUN apt-get -y update
RUN apt-get -y install vim net-tools
RUN apt-get -y install curl
RUN apt-get clean


# copy dex files
ENV DEX_ROOT .dex
ADD $DEX_ROOT/bin/dex-worker /opt/dex/bin/dex-worker
ADD $DEX_ROOT/bin/dex-overlord /opt/dex/bin/dex-overlord
ADD $DEX_ROOT/bin/dexctl /opt/dex/bin/dexctl
ADD $DEX_ROOT/bin/example-app /opt/dex/bin/
ADD $DEX_ROOT/bin/example-cli /opt/dex/bin/

ENV DEX_WORKER_HTML_ASSETS /opt/dex/html/
ADD $DEX_ROOT/static/html/* $DEX_WORKER_HTML_ASSETS

ENV DEX_WORKER_EMAIL_TEMPLATES /opt/dex/email/
ADD $DEX_ROOT/static/email/* $DEX_WORKER_EMAIL_TEMPLATES
ADD $DEX_ROOT/static/fixtures/emailer.json.sample $DEX_WORKER_EMAIL_TEMPLATES/emailer.json


ADD docker-entrypoint.sh /entrypoint.sh
#EXPOSE 5000 35357
ENTRYPOINT ["/entrypoint.sh"]
