elasticsearch extension
=======================

## api
curl http://es.io:9200/index/_search
curl http://es.io:9200/index/type/_search

curl http://es.io:9200/_cat/master?v
curl http://es.io:9200/_cat/master?help
curl http://es.io:9200/_cat/nodes?h=ip,port,heapPercent,name
curl http://es.io:9200/_cat/nodeattrs

curl http://es.io:9200/_cat/indices?bytes=b
curl http://es.io:9200/_cat/allocation?v
curl http://es.io:9200/_cat/count
curl http://es.io:9200/_cat/count/index

curl http://es.io:9200/_cat/plugins?v
curl http://es.io:9200/_cat/repositories?v
curl http://es.io:9200/_cat/snapshots/repo?v

curl http://es.io:9200/_cat/shards
curl http://es.io:9200/_cat/shards/index
curl http://es.io:9200/_cat/segments
curl http://es.io:9200/_cat/segments/index

curl http://es.io:9200/_cat/health
curl http://es.io:9200/_cat/recovery

curl http://es.io:9200/_nodes
curl http://es.io:9200/_nodes/hot_threads
curl http://es.io:9200/_nodes/node1,node2/_all
curl http://es.io:9200/_nodes/process?pretty
curl http://es.io:9200/_nodes/stats
curl http://es.io:9200/_nodes/node1,node2/stats

curl http://es.io:9200/_cluster/health
curl http://es.io:9200/_cluster/health/index1,index2
curl http://es.io:9200/_cluster/state
curl http://es.io:9200/_cluster/settings


## elasticsearch.yml
path:
    logs: /var/log/elasticsearch
    data: /var/data/elasticsearch


## web management
bin/plugin install mobz/elasticsearch-head
http://es.io:9200/_plugin/head/

bin/plugin install royrusso/elasticsearch-HQ
http://es.io:9200//_plugin/hq/




## smartcn plugin
bin/plugin install analysis-smartcn
bin/plugin remove analysis-smartcn
The plugin provides the smartcn analyzer and smartcn_tokenizer tokenizer, which are not configurable.


## elasticsearch-sql
http://localhost:9200/_plugin/sql/
http://localhost:9200/_sql?sql=select * from indexName limit 10
http://localhost:9200/_sql/_explain?sql=select * from indexName limit 10

SELECT address FROM bank WHERE address = matchQuery('880 Holmes Lane') ORDER BY _score DESC LIMIT 3
SELECT COUNT(age) FROM bank GROUP BY range(age, 20,25,30,35,40)
SELECT * FROM locations WHERE GEO_BOUNDING_BOX(fieldname,100.0,1.0,101,0.0)
SELECT online FROM online GROUP BY date_histogram(field='insert_time','interval'='1d')
SELECT * FROM indexName/type


## siren-join
http://localhost:9200/index/_coordinate_search
http://localhost:9200/index/type/_coordinate_search
keyword: filterjoin, indices, types, path, query, orderBy


## elasticsearch auth by shield
bin/plugin install license
bin/plugin install shield


shield:
  authc:
    realms:
      ldap1:
        type: ldap
        order: 0
        url: "ldap://ldap.io:636"
        bind_dn: "cn=ldapuser, ou=users, o=services, dc=ldap, dc=io"
        bind_password: ldappass
        user_search:
          base_dn: "dc=ldap,dc=io"
          attribute: cn
        group_search:
          base_dn: "dc=ldap,dc=io"
        files:
          role_mapping: "CONFIG_DIR/shield/role_mapping.yml"
        unmapped_groups_as_roles: false


monitoring: 
  - "cn=admins,dc=lark,dc=io" 
user:
  - "cn=users,dc=lark,dc=io" 
  - "cn=admins,dc=lark,dc=io"

