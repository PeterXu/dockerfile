#!/bin/bash
#set -e

if [[ $API_KEY ]]; then
    sed -i -e "s/^.*api_key:.*$/api_key: ${API_KEY}/" /etc/dd-agent/datadog.conf
else
    echo "You must set API_KEY environment variable to run the Datadog Agent container"
    exit 1
fi

if [[ $TAGS ]]; then
    sed -i -e "s/^#tags:.*$/tags: ${TAGS}/" /etc/dd-agent/datadog.conf
fi

if [[ $LOG_LEVEL ]]; then
    sed -i -e"s/^.*log_level:.*$/log_level: ${LOG_LEVEL}/" /etc/dd-agent/datadog.conf
fi

if [[ $DD_URL ]]; then
    sed -i -e 's@^.*dd_url:.*$@dd_url: '${DD_URL}'@' /etc/dd-agent/datadog.conf
fi

if [[ $PROXY_HOST ]]; then
    sed -i -e "s/^# proxy_host:.*$/proxy_host: ${PROXY_HOST}/" /etc/dd-agent/datadog.conf
fi

if [[ $PROXY_PORT ]]; then
    sed -i -e "s/^# proxy_port:.*$/proxy_port: ${PROXY_PORT}/" /etc/dd-agent/datadog.conf
fi

if [[ $PROXY_USER ]]; then
    sed -i -e "s/^# proxy_user:.*$/proxy_user: ${PROXY_USER}/" /etc/dd-agent/datadog.conf
fi

if [[ $PROXY_PASSWORD ]]; then
    sed -i -e "s/^# proxy_password:.*$/proxy_password: ${PROXY_PASSWORD}/" /etc/dd-agent/datadog.conf
fi

if [[ $STATSD_FORWARD_HOST ]]; then
    keyword="statsd_forward_host"
    sed -i -e "s/^# ${keyword}:.*$/${keyword}: ${STATSD_FORWARD_HOST}/" /etc/dd-agent/datadog.conf

    keyword="statsd_forward_port"
    sed -i -e "s/^# ${keyword}:.*$/${keyword}: 8125/" /etc/dd-agent/datadog.conf
fi

if [[ $STATSD_METRIC_NAMESPACE ]]; then
    keyword="statsd_metric_namespace"
    sed -i -e "s/^# ${keyword}:.*$/${keyword}: ${STATSD_METRIC_NAMESPACE}/" /etc/dd-agent/datadog.conf
fi

find /conf.d -name '*.yaml' -exec cp {} /etc/dd-agent/conf.d \;

find /checks.d -name '*.py' -exec cp {} /etc/dd-agent/checks.d \;

export PATH="/opt/datadog-agent/embedded/bin:/opt/datadog-agent/bin:$PATH"

cp -f /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

exec "$@"
