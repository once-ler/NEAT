#
# ElasticSearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#
 
# Pull base image.
FROM htaox/elasticsearch-base:0.90.13
MAINTAINER htaox htaox@hotmail.com

ADD files /root/elasticsearch_worker_files
RUN chmod 700 /root/elasticsearch_worker_files/run_elasticsearch_worker.sh
CMD ["/root/elasticsearch_worker_files/run_elasticsearch_worker.sh"]
