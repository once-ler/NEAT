#!/bin/bash

rm "${HBASE_HOME}/logs"/* 

echo -n "starting zookeeper"
"${HBASE_HOME}/bin"/hbase-daemons.sh --config "${HBASE_CONF_DIR}" start zookeeper
#Simple test to see if zookeeper started
while [ 1 ];
do
	if [ -f "${HBASE_HOME}/logs"/*zookeeper*.log ]
    then    
        break
    else
        sleep 1
    fi
done

echo -n "starting HBase master"
"${HBASE_HOME}/bin"/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master 
while [ 1 ];
do
	tail -f "${HBASE_HOME}/logs"/*.out
        sleep 1
done
