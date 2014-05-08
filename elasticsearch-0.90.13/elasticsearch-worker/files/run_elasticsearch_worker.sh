#!/bin/bash

env

echo 'Starting Elasticsearch Worker'

IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
echo "WORKER_IP=$IP"

sed -i "s/@IP@/$IP/g" $ES_HOME/conf/elasticsearch.yml

sed -i "s/@MASTER@/false/g" $ES_HOME/conf/elasticsearch.yml
sed -i "s/@DATA@/true/g" $ES_HOME/conf/elasticsearch.yml

ENV ES_HEAP_SIZE 2g

sudo -u elasticsearch $ES_HOME/bin/elasticsearch -f