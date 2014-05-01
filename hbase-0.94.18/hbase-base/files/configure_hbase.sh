#!/bin/bash

source /root/hadoop_files/configure_hadoop.sh

function create_hbase_directories() {
    create_hadoop_directories
    rm -rf /opt/hbase-$HBASE_VERSION/work
    mkdir -p /opt/hbase-$HBASE_VERSION/work
    chown hdfs.hdfs /opt/hbase-$HBASE_VERSION/work
    mkdir /tmp/hbase
    chown hdfs.hdfs /tmp/hbase
    # this one is for hbase shell logging
    rm -rf /var/lib/hadoop/hdfs
    mkdir -p /var/lib/hadoop/hdfs
    chown hdfs.hdfs /var/lib/hadoop/hdfs
    rm -rf /opt/hbase-$HBASE_VERSION/logs
    mkdir -p /opt/hbase-$HBASE_VERSION/logs
    chown hdfs.hdfs /opt/hbase-$HBASE_VERSION/logs
    
    chown hdfs.hdfs /usr/local/zookeeper
    mkdir /tmp/zookeeper
    chown hdfs.hdfs /tmp/zookeeper
}

function deploy_hbase_files() {
    deploy_hadoop_files
    cp /root/hbase_files/hbase-env.sh /opt/hbase-$HBASE_VERSION/conf/
    cp /root/hbase_files/log4j.properties /opt/hbase-$HBASE_VERSION/conf/
}		

function configure_hbase() {
    configure_hadoop $1
    sed -i s/__MASTER__/master/ /opt/hbase-$HBASE_VERSION/conf/hbase-env.sh
    sed -i s/__HBASE_HOME__/"\/opt\/hbase-${HBASE_VERSION}"/ /opt/hbase-$HBASE_VERSION/conf/hbase-env.sh
    sed -i s/__JAVA_HOME__/"\/usr\/lib\/jvm\/java-7-openjdk-amd64"/ /opt/hbase-$HBASE_VERSION/conf/hbase-env.sh
	
	sed -i "s/@IP@/$1/g" $HBASE_HOME/conf/hbase-site.xml
	sed -i "s/@IP@/$1/g" $ZOO_HOME/conf/zoo.cfg
	#echo "$1 $(hostname)" >> /etc/hosts
}

function prepare_hbase() {
    create_hbase_directories
    deploy_hbase_files
    configure_hbase $1
}
