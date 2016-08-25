Elastic Search
==============

[docs](https://www.gitbook.com/book/looly/elasticsearch-the-definitive-guide-cn)

Elasticsearch集群可以包含多个索引(indices)（数据库），每一个索引可以包含多个类型(types)（表），每一个类型包含多个文档(documents)（行），然后每个文档包含多个字段(Fields)（列）。

Elasticsearch -> Indices   -> Types  -> Documents -> Fields

(Relational DB -> Databases -> Tables -> Rows -> Columns)


# check elastic search
curl -i http://localhost:9200/_cluster/health
curl -i http://localhost:9200/?pretty
./bin/plugin install ..


# http request (json)
curl -X<VERB> '<PROTOCOL>://<HOST>:<PORT>/<PATH>?<QUERY_STRING>' -d '<BODY>'


# compute the number of document in Elastic
curl -XGET http://localhost:9200/_count?pretty -d '{"query": {"match_all": {}}}'


