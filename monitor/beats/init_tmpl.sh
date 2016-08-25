#!/bin/bash

exit 0

# step 1
curl -XPUT http://localhost:9200/_template/topbeat -d@tmpl/topbeat.template.json
curl -XPUT http://localhost:9200/_template/filebeat -d@tmpl/filebeat.template.json
curl -XPUT http://localhost:9200/_template/packetbeat -d@tmpl/packetbeat.template.json


# step2
#git clone https://github.com/elastic/beats-dashboards.git && git checkout 1.2.0
./load.sh -url localhost:9200


