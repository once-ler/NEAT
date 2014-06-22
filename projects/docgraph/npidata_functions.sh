#!/bin/bash

function download_npidata_file() {

	#Note: we need to remove the header of the file
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  mkdir -p /root/downloads && cd /root/downloads
	  wget http://nppes.viva-it.com/NPPES_Data_Dissemination_June_2014.zip
	  unzip NPPES_Data_Dissemination_June_2014.zip
	  tail -n +2 npidata_20050523-20140608.csv > npidata_20050523-20140608_nohead.csv
	EOF	
}

function move_npidata_file_to_hdfs() {

  ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	chown hdfs.hdfs /root/downloads/npidata_20050523-20140608_nohead.csv
	mv /root/downloads/npidata_20050523-20140608_nohead.csv /tmp/npi.csv 
	sudo -u hdfs hadoop fs -mkdir npi
	sudo -u hdfs hadoop fs -moveFromLocal /tmp/npi.csv /user/hdfs/npi/npi.csv
	cd /root && rm -rf downloads
  EOF
}

function move_scriptfile() {

	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/vertices/script-input.groovy root@${FAUNUS_MASTER_IP}:/tmp/faunus

	# /tmp/faunus/script-input.groovy should be there
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  chown hdfs.hdfs /tmp/faunus/script-input.groovy
	  sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/script-input.groovy /user/hdfs/npi/script-input.groovy
	EOF
}

function move_blueprintsfile() {

	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/vertices/BlueprintsScript.groovy root@${FAUNUS_MASTER_IP}:/tmp/faunus

	# /tmp/faunus/BlueprintsScript.groovy should be there
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  chown hdfs.hdfs /tmp/faunus/BlueprintsScript.groovy
	  sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/BlueprintsScript.groovy /user/hdfs/npi/BlueprintsScript.groovy
	EOF
}

function configure_faunus_npi() {

	#Move scriptfile2titan.properties to faunus-master
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa $NEAT_PROJECTS_DIR/docgraph/config/scriptfile2titan.properties root@${FAUNUS_MASTER_IP}:/opt/faunus/bin

	# /opt/faunus/bin/scriptfile2titan.properties should be there

	# Important: note that "#faunus.graph.output.blueprints.script-file" was initially commented out
	ssh -i $NEAT_DOCKER_DIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${FAUNUS_MASTER_IP} /bin/bash << EOF
	  sed -i "s|^#faunus.graph.output.blueprints.script-file=.*|faunus.graph.output.blueprints.script-file=npi/BlueprintsScript.groovy|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.graph.input.format=.*|faunus.graph.input.format=com.thinkaurelius.faunus.formats.script.ScriptInputFormat|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.input.location=.*|faunus.input.location=npi/npi.csv|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.output.location=.*|faunus.output.location=npi/output|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.graph.input.script.file=.*|faunus.graph.input.script.file=npi/script-input.groovy|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^mapred.job.tracker=.*|mapred.job.tracker=${FAUNUS_MASTER_IP}:9001|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.hostname=.*|faunus.graph.output.titan.storage.hostname=$HBASE_MASTER_IP|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.index.search.hostname=.*|faunus.graph.output.titan.storage.index.search.hostname=$ELASTICSEARCH_MASTER_IP|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.tablename=.*|faunus.graph.output.titan.storage.tablename=healthcare|" /opt/faunus/bin/sequencefile-titan.properties
	  sed -i "s|^faunus.graph.output.titan.storage.index.search.index-name=.*|faunus.graph.output.titan.storage.index.search.index-name=healthcare|" /opt/faunus/bin/sequencefile-titan.properties
	EOF
}