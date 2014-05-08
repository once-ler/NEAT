#
# ElasticSearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#
 
# Pull base image.
FROM htaox/elasticsearch-base:0.90.13
MAINTAINER htaox htaox@hotmail.com

RUN IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
RUN echo "ES_IP=$IP"
RUN sed -i "s/@IP@/$IP/g" $ES_HOME/conf/elasticsearch.yml

RUN sed -i "s/@MASTER@/false/g" $ES_HOME/conf/elasticsearch.yml
RUN sed -i "s/@DATA@/true/g" $ES_HOME/conf/elasticsearch.yml

CMD ["/elasticsearch/bin/default_cmd"]
