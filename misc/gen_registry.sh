#!/usr/bin/env bash

server_name="_"
server_conf="/var/lib/nginx_conf"
mkdir -p $server_conf

# This is the main nginx configuration you will use
cat <<EOF > $server_conf/nginx.conf
upstream docker-registry {
  server registry:5000;
}

## Set a variable to help us decide if we need to add the
## 'Docker-Distribution-Api-Version' header.
## The registry always sets this header.
## In the case of nginx performing auth, the header will be unset
## since nginx is auth-ing before proxying.
map \$upstream_http_docker_distribution_api_version \$docker_distribution_api_version {
  'registry/2.0' '';
  default registry/2.0;
}

server {
  listen 443 ssl;
  server_name $server_name;

  # SSL
  ssl_certificate /etc/nginx/conf.d/ssl-cert.crt;
  ssl_certificate_key /etc/nginx/conf.d/ssl-cert.key;

  # Recommendations from https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;

  # disable any limits to avoid HTTP 413 for large image uploads
  client_max_body_size 0;

  # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
  chunked_transfer_encoding on;

  location /v2/ {
    # Do not allow connections from docker 1.5 and earlier
    # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
    if (\$http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
      return 404;
    }

    # To add basic authentication to v2 use auth_basic setting.
    auth_basic "Registry realm";
    auth_basic_user_file /etc/nginx/conf.d/nginx.htpasswd;

    ## If  is empty, the header will not be added.
    ## See the map directive above where this variable is defined.
    add_header 'Docker-Distribution-Api-Version'  always;

    proxy_pass                          http://docker-registry;
    proxy_set_header  Host              \$http_host;   # required for docker client's sake
    proxy_set_header  X-Real-IP         \$remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   \$proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto \$scheme;
    proxy_read_timeout                  900;
  }
}
EOF


# Now, create a password file for "testuser" and "testpassword"
docker run --entrypoint htpasswd httpd:latest -bn xyz xyzpass > $server_conf/nginx.htpasswd

# Copy over your certificate files
cp -f /tmp/cert_pems/* $server_conf

# Now create your compose file

cat <<EOF > docker-compose.yml
nginx:
  image: "lark.io/nginx:latest"
  ports:
    - 443:443
  links:
    - registry:registry
  volumes:
    - $server_conf:/etc/nginx/conf.d

registry:
  image: lark.io/registry:2
  ports:
    - 127.0.0.1:5000:5000
  volumes:
    - /var/zdisk/var/lib/registry:/var/lib/registry
EOF

