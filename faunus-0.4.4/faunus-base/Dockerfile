# FAUNUS 0.4.4
#
FROM apache-hadoop-hdfs-precise:1.2.1
MAINTAINER htaox htaox@hotmail.com

# Download and Install HBase
ENV FAUNUS_VERSION 0.4.4

RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise-security main universe' >> /etc/apt/sources.list
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise-updates main universe' >> /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y -q git maven

RUN git clone https://github.com/thinkaurelius/faunus.git
RUN mvn install -f ./faunus/pom.xml -DskipTests
RUN mv ./faunus /opt/faunus-$FAUNUS_VERSION
RUN ln -s /opt/faunus-$FAUNUS_VERSION /opt/faunus

ENV FAUNUS_HOME /opt/faunus

ADD files /root/faunus_files 
