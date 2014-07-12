# GIRAPH 1.1.0
#
FROM htaox/oracle-java8-hadoop:1.2.1
MAINTAINER htaox htaox@hotmail.com

RUN cd /opt

RUN git clone https://github.com/apache/giraph.git

ENV GIRAPH_HOME /opt/giraph
ENV GIRAPH_VERSION 1.1.0

RUN cd giraph && mvn clean package -DskipTests

# core JAR is in $GIRAPH_HOME/giraph-core/target/giraph-1.1.0-SNAPSHOT-for-hadoop-1.2.1-jar-with-dependencies.jar

ADD files /root/giraph_files



