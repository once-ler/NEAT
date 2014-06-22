#!/bin/bash

## After starting the nameserver 
## Check your /tmp/DNSMASQ for the DNS directory file and look for "faunus-master" ip address ##

BASEDIR=~/NEAT/docker-scripts
MASTER_IP=$(cat $(cat /tmp/DNSMASQ) | grep faunus-master | awk -F'/' '{print $3}' | sed 's|"||')
chmod 400 $BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa