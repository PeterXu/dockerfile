FROM lark.io/alpine:lts
MAINTAINER Peter <peter@uskee.org>

RUN apk update
RUN apk add -u bash
RUN apk add -u alpine-conf
RUN setup-timezone -z Asia/Shanghai

ADD swarm /swarm
ENTRYPOINT ["/swarm"]
CMD ["--help"]
