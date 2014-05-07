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

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
ENTRYPOINT ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

ADD files /root/elasticsearch_files

ADD files/elasticsearch.yml $ES_HOME/conf/elasticsearch.yml

RUN IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
RUN echo "ES_IP=$IP"
RUN sed -i "s/@IP@/$IP/g" $ES_HOME/conf/elasticsearch.yml
