#
# ElasticSearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#
 
# Pull base image.
FROM htaox/elasticsearch-base:0.90.13
MAINTAINER htaox htaox@hotmail.com

RUN sed -i "s/@MASTER@/true/g" $ES_HOME/conf/elasticsearch.yml
RUN sed -i "s/@DATA@/false/g" $ES_HOME/conf/elasticsearch.yml

ENV ES_HEAP_SIZE 1g
