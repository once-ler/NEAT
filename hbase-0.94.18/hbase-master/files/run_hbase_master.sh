#!/bin/bash
#/opt/spark-0.9.0/sbin/start-master.sh

"${HBASE_HOME}/bin"/hbase-daemons.sh --config "${HBASE_CONF_DIR}" start zookeeper
"${HBASE_HOME}/bin"/hbase-daemon.sh --config "${HBASE_CONF_DIR}" start master 

while [ 1 ];
do
	tail -f /opt/hbase-${HBASE_VERSION}/logs/*.out
        sleep 1
done
