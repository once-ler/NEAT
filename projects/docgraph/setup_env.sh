#!/bin/bash

## After starting the nameserver 
## Check your /tmp/DNSMASQ for the DNS directory file and look for "faunus-master" ip address ##

## Important! Make sure NEAT_HOME is set!!
## For example, NEAT_HOME=~/NEAT
NEAT_DOCKER_DIR=$NEAT_HOME/docker-scripts
NEAT_PROJECTS_DIR=$NEAT_HOME/projects
HBASE_MASTER_IP=$(cat $(cat /tmp/DNSMASQ) | grep hbase-master | awk -F'/' '{print $3}' | sed 's|"||')
ELASTICSEARCH_MASTER_IP=$(cat $(cat /tmp/DNSMASQ) | grep elasticsearch-master | awk -F'/' '{print $3}' | sed 's|"||')
FAUNUS_MASTER_IP=$(cat $(cat /tmp/DNSMASQ) | grep faunus-master | awk -F'/' '{print $3}' | sed 's|"||')
chmod 400 $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa