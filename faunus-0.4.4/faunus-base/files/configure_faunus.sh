#!/bin/bash

source /root/hadoop_files/configure_hadoop.sh

function create_faunus_directories() {
    create_hadoop_directories
    rm -rf /opt/faunus-$FAUNUS_VERSION/work
    mkdir -p /opt/faunus-$FAUNUS_VERSION/work
    chown hdfs.hdfs /opt/faunus-$FAUNUS_VERSION/work
    mkdir /tmp/faunus
    chown hdfs.hdfs /tmp/faunus
    # this one is for faunus shell logging
    rm -rf /var/lib/hadoop/hdfs
    mkdir -p /var/lib/hadoop/hdfs
    chown hdfs.hdfs /var/lib/hadoop/hdfs
    #rm -rf /opt/faunus-$FAUNUS_VERSION/logs
    #mkdir -p /opt/faunus-$FAUNUS_VERSION/logs
    #chown hdfs.hdfs /opt/faunus-$FAUNUS_VERSION/logs    
}

function deploy_faunus_files() {
    deploy_hadoop_files
    #cp /root/faunus_files/faunus-env.sh /opt/faunus-$FAUNUS_VERSION/conf/
    #cp /root/faunus_files/log4j.properties /opt/faunus-$FAUNUS_VERSION/conf/
}		

function configure_faunus() {
    configure_hadoop $1
    #sed -i s/__MASTER__/master/ /opt/faunus-$FAUNUS_VERSION/conf/faunus-env.sh
}

function prepare_faunus() {
    create_faunus_directories
    deploy_faunus_files
    configure_faunus $1
}
