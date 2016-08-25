#!/bin/bash

conf="/opt/kibana/config/kibi.yml"

set_config() {
    if [ "$esUsername" ]; then
        sed -ri "s!^(\#\s*)?(elasticsearch\.username:).*!\2 '$esUsername'!" $conf
    fi

    if [ "$esPassword" ]; then
        sed -ri "s!^(\#\s*)?(elasticsearch\.password:).*!\2 '$esPassword'!" $conf
    fi
    
    #if [ "$ELASTICSEARCH_URL" ]; then
    #    sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" $conf
    #fi

    rm -f ${conf}n
}

set_config


# redirect to origin entrypoing
source /docker-entrypoint.sh
