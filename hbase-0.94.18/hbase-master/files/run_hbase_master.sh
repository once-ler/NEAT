#!/bin/bash

rm "${HBASE_HOME}/logs"/* 

echo -n "starting zookeeper"
"${HBASE_HOME}/bin"/hbase-daemons.sh --config "${HBASE_CONF_DIR}" start zookeeper

sleep 3

echo -n "starting HBase master"
"${HBASE_HOME}/bin"/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master 
while [ 1 ];
do
	tail -f "${HBASE_HOME}/logs"/*.out
        sleep 1
done
