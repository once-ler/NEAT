# FAUNUS 0.4.4
#
FROM apache-hadoop-hdfs-precise:1.2.1
MAINTAINER htaox htaox@hotmail.com

# Download and Install HBase
ENV FAUNUS_VERSION 0.4.4

RUN apt-get install -y -q git maven

RUN git clone https://github.com/Lab41/titan.git
RUN cd /titan; git checkout dendrite-hadoop2
RUN mvn install -f /titan/pom.xml -DskipTests

RUN git clone https://github.com/thinkaurelius/faunus.git
RUN mvn install -f ./faunus/pom.xml -DskipTests
RUN mv ./faunus /opt/faunus-$FAUNUS_VERSION
RUN ln -s /opt/faunus-$FAUNUS_VERSION /opt/faunus

ENV FAUNUS_HOME /opt/faunus

ADD files /root/faunus_files 
