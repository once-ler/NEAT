#
# ElasticSearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#
 
# Pull base image.
FROM dockerfile/java
 
# Install ElasticSearch.
RUN cd /tmp && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.13.tar.gz
RUN cd /tmp && tar xvzf elasticsearch-0.90.13.tar.gz && rm -f elasticsearch-0.90.13.tar.gz
RUN mv /tmp/elasticsearch-0.90.13 /elasticsearch
ENV ES_HOME /elasticsearch

# Install elasticsearch-head
RUN /elasticsearch/bin/plugin -install mobz/elasticsearch-head

# Create elasticsearch user
ENV ES_USER elasticsearch
ENV ES_GROUP elasticsearch

RUN addgroup elasticsearch
RUN useradd elasticsearch -g elasticsearch
# RUN adduser --ingroup elasticsearch elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
# ENTRYPOINT ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

ADD files /root/elasticsearch_files
ADD files/elasticsearch.yml $ES_HOME/conf/elasticsearch.yml

RUN chown -R elasticsearch.elasticsearch $ES_HOME
