cat <<EOF >/var/lib/nginx_conf/ldap.conf
url ldap://ldap/dc=example,dc=com?samaccountname?sub?(objectClass=user);
binddn ldap@example.com;
binddn_passwd secretPassword;
group_attribute uniquemember;
group_attribute_is_dn on;
require group 'cn=docker,ou=groups,dc=example,dc=com';
require valid_user;
satisfy all; 
EOF


#docker run --name registry-ldap-auth --link ldap:ldap --link registry:docker-registry -v /ssl/cert/path:/etc/ssl/docker:ro -v `pwd`/sample-ldap.conf:/etc/nginx/ldap.conf:ro -p 443:443 -p 5000:5000 -d h3nrik/registry-ldap-auth
cat <<EOF >docker-compose.yml
openldap:
    image: osixia/openldap:latest
    environment:
        - LDAP_ORGANISATION="uskee"
        - LDAP_DOMAIN="uskee.org"
        - LDAP_ADMIN_PASSWORD="xyzpass"

registry:
    image: registry:2
    ports:
        - 127.0.0.1:5000:5000
    volumes:
        - /var/zdisk/var/lib/registry:/var/lib/registry

registry-ldap-auth:
    image: h3nrik/registry-ldap-auth
    links:
        - openldap:ldap
        - registry:docker-registry
    volumes:
        - /var/lib/nginx_conf:/etc/ssl/docker:ro
        - /var/lib/nginx_conf/ldap.conf:/etc/nginx/ldap.conf:ro
    ports:
        - 443:443
        - 5000:5000
EOF

