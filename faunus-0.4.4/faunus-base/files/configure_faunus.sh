#!/bin/bash

source /root/hadoop_files/configure_hadoop.sh

function create_faunus_directories() {
    create_hadoop_directories
    rm -rf /opt/faunus-$FAUNUS_VERSION/work
    mkdir -p /opt/faunus-$FAUNUS_VERSION/work
    chown hdfs.hdfs /opt/faunus-$FAUNUS_VERSION/work
    mkdir /tmp/faunus
    chown hdfs.hdfs /tmp/faunus
    
    rm -rf /var/lib/hadoop/hdfs
    mkdir -p /var/lib/hadoop/hdfs
    chown hdfs.hdfs /var/lib/hadoop/hdfs    
}

function deploy_faunus_files() {
    deploy_hadoop_files
    echo 'FAUNUS_HOME=/opt/faunus' >> /etc/environment    
}		

function configure_faunus() {
    configure_hadoop $1

    # Copy mapred.xml to hadoop conf dir
    cp /root/faunus_files/mapred.xml /etc/hadoop/mapred.xml

    # Update JobTracker IP
    sed -i "s/@IP@/$1/g" $HBASE_HOME/conf/mapred.xml
}

function prepare_faunus() {
    create_faunus_directories
    deploy_faunus_files
    configure_faunus $1
}
