#!/bin/bash

set -e

# Add kibi as command if needed
if [[ "$1" == -* ]]; then
	set -- kibi "$@"
fi

# Run as user "kibi" if the command is "kibi"
if [ "$1" = 'kibi' ]; then
	if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
		: ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
		sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibi.yml
	else
		echo >&2 'warning: missing ELASTICSEARCH_PORT_9200_TCP or ELASTICSEARCH_URL'
		echo >&2 '  Did you forget to --link some-elasticsearch:elasticsearch'
		echo >&2 '  or -e ELASTICSEARCH_URL=http://some-elasticsearch:9200 ?'
		echo >&2
	fi
	
	set -- gosu kibana tini -- "$@"
fi

exec "$@"
