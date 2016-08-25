monitor/logger
==============

beats: filebeat/topbeat/packetbeat

beats => logstash => elasticsearch => kibana
beats => logstash => elasticsearch => elastalert

beats => logstash => kafka => Gobblin => hadoop(hbase+hdfs) => hive/pig/SparkSql
beats => logstash => kafka => SparkSql


clusters
========

consul cluster
etcd cluster
zookeeper cluster

elasticsearch cluster
kafka cluster
hadoop cluster


elasticsearch discovery
=======================
    1. elasticsearch-srv-discovery
    bin/plugin install srv-discovery --url https://github.com/github/elasticsearch-srv-discovery/releases/download/1.5.1/elasticsearch-srv-discovery-1.5.1.zip

    ```
    discovery:
      type: srv
      srv:
            query: elasticsearch-9300.service.consul
            protocol: tcp
            servers:
               - 127.0.0.1:8600
               - 192.168.1.1
    ```

    2. elasticsearch-zookeeper
    bin/plugin -url https://github.com/grmblfrz/elasticsearch-zookeeper/releases/download/v1.7.1/elasticsearch-zookeeper-1.7.1.zip -install zookeeper
    
    ```
        discovery:
            type: com.sonian.elasticsearch.zookeeper.discovery.ZooKeeperDiscoveryModule
        sonian.elasticsearch.zookeeper:
            settings.enabled: true
            client.host: localhost:2181
            discovery.state_publishing.enabled: true
    ```




