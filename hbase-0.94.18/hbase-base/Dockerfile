# HBASE 0.94.18
#
FROM apache-hadoop-hdfs-precise:1.2.1
MAINTAINER htaox htaox@hotmail.com

# Intall cURL
RUN apt-get install -y curl 

# Download and Install HBase
ENV HBASE_VERSION 0.94.18

#RUN mkdir -p /opt/downloads && cd /opt/downloads && curl -SsfLO "http://www.apache.org/dcd ist/hbase/hbase-$HBASE_VERSION/hbase-$HBASE_VERSION.tar.gz"
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

RUN rm $HBASE_HOME/conf/hbase-site.xml
ADD files/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

RUN rm $HBASE_HOME/conf/hbase-env.sh
ADD files/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh

# Download and install Zookeeper 3.4.6
RUN curl -s http://xenia.sote.hu/ftp/mirrors/www.apache.org/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xz -C /usr/local/
#RUN cd /usr/local && ln -s zookeeper-3.4.6 zookeeper
RUN ln -s /usr/local/zookeeper-3.4.6 /usr/local/zookeeper
ENV ZOO_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZOO_HOME/bin
#RUN mv $ZOO_HOME/conf/zoo_sample.cfg $ZOO_HOME/conf/zoo.cfg

ADD files/zoo.cfg $ZOO_HOME/conf/zoo.cfg
ADD files/zkEnv.sh $ZOO_HOME/bin/zkEnv.sh

# Ports reference
# http://blog.cloudera.com/blog/2013/07/guide-to-using-apache-hbase-ports/

# Expose zookeeper
EXPOSE 2181

# Expose HBase Master Ports
# HBase Master web UI at :60010/master-status;  ZK at :60010/zk.jsp
EXPOSE 60000 60010 

# Expose HBase Region Server Ports
EXPOSE 60020 60030 

# Expose REST Server Ports
EXPOSE 8080 8085

# Expose Thrift Ports
EXPOSE 9090 9095

ADD files /root/hbase_files

