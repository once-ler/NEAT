#!/bin/bash

source $NEAT_HOME/docgraph/setup_env.sh
source $NEAT_HOME/docgraph/docgraph_functions.sh
source $NEAT_HOME/docgraph/npidata_functions.sh

download_npidata_file

move_npidata_file_to_hdfs

moveDocgraphToHdfs

move_scriptfile

move_blueprintsfile

configure_faunus_npi

create_start_job

start_job
