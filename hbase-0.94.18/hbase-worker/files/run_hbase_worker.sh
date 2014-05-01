#!/bin/bash
#. /opt/hbase-0.94.18/conf/hbase-env.sh
# ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker $MASTER

"${HBASE_HOME}/bin"/hbase-daemons.sh --config "${HBASE_CONF_DIR}" start regionserver
while [ 1 ];
do
	tail -f "${HBASE_HOME}/logs"/*.out
        sleep 1
done