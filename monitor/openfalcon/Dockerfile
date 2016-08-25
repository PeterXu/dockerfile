FROM lark.io/ubuntu:lts


ENV HOME /opt/
ENV WORKSPACE $HOME/openfalcon

ADD files/falcon-transfer-0.0.17.tar.gz $WORKSPACE/transfer
ADD files/falcon-agent-5.1.0.tar.gz $WORKSPACE/agent
ADD files/falcon-graph-0.5.6.tar.gz $WORKSPACE/graph
ADD files/falcon-query-1.4.3.tar.gz $WORKSPACE/query
ADD files/falcon-dashboard-35dbee7.tar.gz $WORKSPACE/dashboard

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
