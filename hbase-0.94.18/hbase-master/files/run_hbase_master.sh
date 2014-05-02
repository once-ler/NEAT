#!/bin/bash

echo -n "starting zookeeper"
$ZOO_HOME/bin/zkServer.sh start

sleep 3

echo -n "starting HBase master"
"${HBASE_HOME}/bin"/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master 
