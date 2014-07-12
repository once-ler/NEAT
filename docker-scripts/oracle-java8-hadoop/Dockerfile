# Base Ubuntu Precise 12.04 LTS w/ Hadoop 1.2.1 image
#
FROM htaox/apache-hadoop-hdfs-precise:1.2.1
MAINTAINER htaox htaox@hotmail.com

# install Oracle Java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update

# auto accept oracle jdk license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer ca-certificates

# Install tools
run apt-get install -y git maven curl