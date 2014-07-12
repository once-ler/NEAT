#!/bin/bash

source /root/hadoop_files/configure_hadoop.sh

function create_giraph_directories() {
    create_hadoop_directories
    rm -rf /opt/giraph-$GIRAPH_VERSION/work
    mkdir -p /opt/giraph-$GIRAPH_VERSION/work
    chown hdfs.hdfs /opt/giraph-$GIRAPH_VERSION/work
    mkdir /tmp/giraph
    chown hdfs.hdfs /tmp/giraph
    # this one is for GIRAPH shell logging
    rm -rf /var/lib/hadoop/hdfs
    mkdir -p /var/lib/hadoop/hdfs
    chown hdfs.hdfs /var/lib/hadoop/hdfs
    rm -rf /opt/giraph-$GIRAPH_VERSION/logs
    mkdir -p /opt/giraph-$GIRAPH_VERSION/logs
    chown hdfs.hdfs /opt/giraph-$GIRAPH_VERSION/logs    
}

function deploy_giraph_files() {
    deploy_hadoop_files
}   

function configure_giraph() {
    configure_hadoop $1
}

function prepare_giraph() {
    create_giraph_directories
    deploy_giraph_files
    configure_giraph $1
}
