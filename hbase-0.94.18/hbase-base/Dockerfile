# HBASE 0.94.18
#
FROM apache-hadoop-hdfs-precise:1.2.1

MAINTAINER htaox htaox@hotmail.com

# Download and Install HBase
ENV HBASE_VERSION 0.94.18

#RUN mkdir -p /opt/downloads && cd /opt/downloads && curl -SsfLO "http://www.apache.org/dist/hbase/hbase-$HBASE_VERSION/hbase-$HBASE_VERSION.tar.gz"
RUN mkdir -p /opt/downloads
ADD http://www.apache.org/dist/hbase/hbase-$HBASE_VERSION/hbase-$HBASE_VERSION.tar.gz /opt/downloads/hbase-$HBASE_VERSION.tar.gz

RUN cd /opt && tar xvfz /opt/downloads/hbase-$HBASE_VERSION.tar.gz
# RUN mv /opt/hbase-$HBASE_VERSION /opt/hbase
# Add symlink
RUN ln -s /opt/hbase-$HBASE_VERSION /opt/hbase

# Data will go here (see hbase-site.xml)
# RUN mkdir -p /data/hbase /opt/hbase/logs

# ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64
ENV HBASE_HOME /opt/hbase
ENV HBASE_PREFIX /opt/hbase
ENV PATH $PATH:$HBASE_HOME/bin
ENV HBASE_CONF_DIR /opt/hbase/conf
#ENV HBASE_SERVER /opt/hbase/bin/hbase

#ADD ./hbase-site.xml /opt/hbase/conf/hbase-site.xml
#ADD ./zoo.cfg /opt/hbase/conf/zoo.cfg
#ADD ./hbase-server /opt/hbase-server

RUN rm $HBASE_HOME/conf/hbase-site.xml
ADD files/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

RUN rm $HBASE_HOME/conf/hbase-env.sh
ADD files/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh

ADD files/zoo.cfg $HBASE_HOME/conf/zoo.cfg

# Ports reference
# http://blog.cloudera.com/blog/2013/07/guide-to-using-apache-hbase-ports/

# Expose zookeeper
EXPOSE 2181

# Expose HBase Master Ports
EXPOSE 60000 60010 

# Expose HBase Region Server Ports
EXPOSE 60020 60030 

# Expose REST Server Ports
EXPOSE 8080 8085

# Expose Thrift Ports
EXPOSE 9090 9095

ADD files /root/hbase_files

