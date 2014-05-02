#!/bin/bash

"${HBASE_HOME}/bin"/hbase-daemons.sh --config "${HBASE_CONF_DIR}" start regionserver
