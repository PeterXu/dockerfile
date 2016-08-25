#!/bin/bash

DEX_ROOT=/opt/dex
cd $DEX_ROOT

set_dex_overload() 
{
    export DEX_OVERLORD_DB_URL=$DEX_DB_URL
    export DEX_OVERLORD_KEY_SECRETS=$DEX_KEY_SECRET
    export DEX_OVERLORD_KEY_PERIOD=${DEX_OVERLORD_KEY_PERIOD:-1h}
    export DEX_OVERLORD_ADMIN_API_SECRET=$(dd if=/dev/urandom bs=1 count=128 2>/dev/null | base64 | tr -d '\n')

    ./bin/dex-overlord &
    echo "Waiting for overlord to start..."
    until $(curl --output /dev/null --silent --fail http://127.0.0.1:5557/health); do
        printf '.'
        sleep 1
    done
}

set_connectors()
{
    # Set up connectors
    DEX_CONNECTORS_FILE=$(mktemp  /tmp/dex-conn.XXXXX)
    DEX_GOOGLE_ISSUER_URL=https://accounts.google.com 
    cat << EOF > $DEX_CONNECTORS_FILE
[
	{
		"type": "local",
		"id": "local"
	},
	{
		"type": "oidc",
		"id": "google",
		"issuerURL": "$DEX_GOOGLE_ISSUER_URL",
		"clientID": "$DEX_GOOGLE_CLIENT_ID",
		"clientSecret": "$DEX_GOOGLE_CLIENT_SECRET",
		"trustedEmailProvider": true
	}
]
EOF

    cat << EOF > $DEX_CONNECTORS_FILE
[
	{
		"type": "local",
		"id": "local"
	}
]
EOF

    ./bin/dexctl --db-url=$DEX_DB_URL set-connector-configs $DEX_CONNECTORS_FILE
}

set_worker()
{
    # Start the worker
    export DEX_WORKER_DB_URL=$DEX_DB_URL
    export DEX_WORKER_KEY_SECRETS=$DEX_KEY_SECRET
    export DEX_WORKER_LOG_DEBUG=1
    export DEX_WORKER_EMAIL_CFG=email/emailer.json
    export DEX_WORKER_ENABLE_REGISTRATION=true

    ./bin/dex-worker &

    echo "Waiting for worker to start..."
    until $(curl --output /dev/null --silent --fail http://127.0.0.1:5556/health); do
        printf '.'
        sleep 1
    done
}

set_client()
{
    # Create a client 
    cat > $DEX_ROOT/set_client.sh <<EOF
    eval "\$(./bin/dexctl --db-url=$DEX_DB_URL new-client http://127.0.0.1:5555/callback)"

    ./bin/example-app --client-id=\$DEX_APP_CLIENT_ID --client-secret=\$DEX_APP_CLIENT_SECRET --discovery=http://127.0.0.1:5556 &

EOF
}


if [ "$DEX_DB_URL" != "" -a "$DEX_KEY_SECRET" != "" ]; then
    set_dex_overload
    set_client
    set_connectors
    set_worker
fi

bash -l
exit 0
