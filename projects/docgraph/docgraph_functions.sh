#!/bin/bash

function downloadDocgraph() {

	### Thank you @spmallette for info that CMS.gov is now hosting the docgraph files
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  cd /tmp/faunus
	  wget http://downloads.cms.gov/foia/physician-referrals-2012-2013-days365.zip
	  mv physician-referrals-2012-2013-days365.zip DocGraph-2012-2013-Days365zip
	  unzip /tmp/faunus/DocGraph-2012-2013-Days365zip
	EOF	
}

function sortDocgraph() {

	### Sorting Docgraph might be the MOST CRUCIAL step
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  sort -t $',' -k 1,1 /tmp/faunus/DocGraph-2012-2013-Days365.csv >/tmp/faunus/DocGraph-2012-2013-Days365_sorted.csv
	EOF
}

function moveDocgraphToHdfs() {

	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  sudo -u hdfs hadoop fs -mkdir npi
	  sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/DocGraph-2012-2013-Days365_sorted.csv /user/hdfs/npi/DocGraph-2012-2013-Days365_sorted.csv
	EOF
}

function configure_titan() {
	#Move titan.properties to faunus-master
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/config/titan.properties root@${FAUNUS_MASTER_IP}:/opt/faunus/bin

	# /opt/faunus/bin/titan.properties should be there
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  sed -i "s|^storage.hostname=.*|storage.hostname=$HBASE_MASTER_IP|" /opt/faunus/bin/titan.properties
	  sed -i "s|^storage.index.search.hostname=.*|storage.index.search.hostname=$ELASTICSEARCH_MASTER_IP|" /opt/faunus/bin/titan.properties
	  sed -i "s|^storage.tablename=.*|storage.tablename=healthcare|" /opt/faunus/bin/titan.properties
	  sed -i "s|storage.index.search.index-name=.*|storage.index.search.index-name=healthcare|" /opt/faunus/bin/titan.properties
	EOF
}

function setup_titan_keys() {

	#Move titan.properties to faunus-master
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/setup/edges-labels.groovy root@${FAUNUS_MASTER_IP}:/tmp
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/setup/vertices-indexes.groovy root@${FAUNUS_MASTER_IP}:/tmp

	# /tmp/edges-labels.groovy should be there
	# /tmp/vertices-indexes.groovy should be there
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  /opt/faunus/bin/gremlin.sh < /tmp/edges-labels.groovy
	  /opt/faunus/bin/gremlin.sh < /tmp/vertices-indexes.groovy
	EOF
}

function move_scriptInputFile() {

	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/edges/script-input-docgraph.groovy root@${FAUNUS_MASTER_IP}:/tmp/faunus
	
	# /tmp/faunus/script-input-docgraph.groovy should be there
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  chown hdfs.hdfs /tmp/faunus/script-input-docgraph.groovy
	  sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/script-input-docgraph.groovy /user/hdfs/npi/script-input-docgraph.groovy
	EOF
}

function configure_faunus_docgraph() {

	#Move scriptfile2titan.properties to faunus-master
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/config/scriptfile2titan.properties root@${FAUNUS_MASTER_IP}:/opt/faunus/bin

	# /opt/faunus/bin/scriptfile2titan.properties should be there
	
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  sed -i "s|^faunus.graph.input.format=.*|faunus.graph.input.format=com.thinkaurelius.faunus.formats.script.ScriptInputFormat|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.input.location=.*|faunus.input.location=npi/DocGraph-2012-2013-Days365_sorted.csv|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.graph.input.script.file=.*|faunus.graph.input.script.file=npi/script-input-docgraph.groovy|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.output.location=.*|faunus.output.location=npi/output-docgraph-titan|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^mapred.job.tracker=.*|mapred.job.tracker=${FAUNUS_MASTER_IP}:9001|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.hostname=.*|faunus.graph.output.titan.storage.hostname=$HBASE_MASTER_IP|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.index.search.hostname=.*|faunus.graph.output.titan.storage.index.search.hostname=$ELASTICSEARCH_MASTER_IP|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.tablename=.*|faunus.graph.output.titan.storage.tablename=healthcare|" /opt/faunus/bin/scriptfile2titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.index.search.index-name=.*|faunus.graph.output.titan.storage.index.search.index-name=healthcare|" /opt/faunus/bin/scriptfile2titan.properties
	EOF
}

function create_start_job() {

	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  rm -rf /tmp/faunus/upload.groovy
	  echo -e "g = FaunusFactory.open('/opt/faunus/bin/scriptfile2titan.properties');\ng._;\ng.shutdown();\n" >> /tmp/faunus/upload.groovy
	EOF
}

function start_job() {

	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  sudo -E -H -u hdfs bash -c "/opt/faunus/bin/gremlin.sh < /tmp/faunus/upload.groovy"
	EOF
}
