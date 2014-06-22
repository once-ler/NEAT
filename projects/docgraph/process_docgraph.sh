#!/bin/bash

WORKINGDIR=$(cd $(dirname $0); pwd)

source $WORKINGDIR/start_nameserver.sh	

function login_faunus_master() {
	#To faunus
	BASEDIR=~/NEAT/docker-scripts
	MASTER_IP=172.17.0.11
	chmod 400 $BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa
	ssh -i $BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${MASTER_IP}
}

function configure_titan() {
	# $FAUNUS_HOME/bin/titan.properties should be there
	sed -i 's|@IP@|172.17.0.3|' $FAUNUS_HOME/bin/titan.properties
	sed -i 's|@ELASTIC_IP@|172.17.0.7|' $FAUNUS_HOME/bin/titan.properties
	sed -i 's|@TABLE@|healthcare|' $FAUNUS_HOME/bin/titan.properties
}

function setup() {


	# /tmp/edges-labels.groovy should be there
	$FAUNUS_HOME/bin/gremlin.sh < /tmp/edges-labels.groovy

	# /tmp/vertices-indexes.groovy should be there
	$FAUNUS_HOME/bin/gremlin.sh < /tmp/vertices-indexes.groovy	
}

function moveDocgraphToMaster() {

	#http://www.docgraph.org/next-generation-docgraph-data/
	#http://bit.ly/DocGraph-2012-2013-Days365zip

	BASEDIR=~/NEAT/docker-scripts
	MASTER_IP=172.17.0.11
	chmod 400 $BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa
	#scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa ~/docgraph/data/DocGraph-2012-2013-Days365zip root@${MASTER_IP}:/tmp/faunus/
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa ~/docgraph/data/docgraph_test.csv root@${MASTER_IP}:/tmp/faunus/
}

function moveDocgraphToHdfs() {
	unzip /tmp/faunus/DocGraph-2012-2013-Days365zip
	sudo -u hdfs hadoop fs -mkdir npi
	sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/DocGraph-2012-2013-Days365.csv /user/hdfs/npi/DocGraph-2012-2013-Days365.csv

	sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/DocGraph-2012-2013-Days365_sorted.csv /user/hdfs/npi/DocGraph-2012-2013-Days365_sorted.csv

	#move test file
	sudo -u hdfs hadoop fs -copyFromLocal /tmp/faunus/docgraph_test.csv /user/hdfs/npi/docgraph_test.csv
}

function move_scriptInputFile() {

	# /tmp/faunus/script-input-docgraph.groovy should be there
	chown hdfs.hdfs /tmp/faunus/script-input-docgraph.groovy
	sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/script-input-docgraph.groovy /user/hdfs/npi/script-input-docgraph.groovy
}
 

###

function configure_faunus() {
	# $FAUNUS_HOME/bin/sequencefile-titan.properties should be there
	
	# PART_FILE=part-m-00000
	# sed -i "s|^faunus.input.location=.*|faunus.input.location=npi/output-docgraph-titan/job-1/$PART_FILE|" $FAUNUS_HOME/bin/sequencefile-titan.properties
	
	# ScriptInputFormat only
	sed -i 's|^faunus.input.location=.*|faunus.input.location=npi/DocGraph-2012-2013-Days365.csv|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.input.script.file=.*|faunus.graph.input.script.file=npi/script-input-docgraph.groovy|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.output.location=.*|faunus.output.location=npi/output-docgraph-titan|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	
	# NPI Only
	sed -i 's|^faunus.graph.output.blueprints.script-file=.*|faunus.graph.output.blueprints.script-file=npi/BlueprintsScript.groovy|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.input.format=.*|faunus.graph.input.format=com.thinkaurelius.faunus.formats.script.ScriptInputFormat|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.input.location=.*|faunus.input.location=npi/npi.csv|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.output.location=.*|faunus.output.location=npi/output|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.input.script.file=.*|faunus.graph.input.script.file=npi/script-input.groovy|' $FAUNUS_HOME/bin/sequencefile-titan.properties

	# HBase only
	#sed -i 's|^faunus.output.location=.*|faunus.output.location=npi/output-docgraph-hbase|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^mapred.job.tracker=.*|mapred.job.tracker=172.17.0.11:9001|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.output.titan.storage.hostname=.*|faunus.graph.output.titan.storage.hostname=172.17.0.3|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.output.titan.storage.index.search.hostname=.*|faunus.graph.output.titan.storage.index.search.hostname=172.17.0.7|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.output.titan.storage.tablename=.*|faunus.graph.output.titan.storage.tablename=healthcare|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.output.titan.storage.index.search.index-name=.*|faunus.graph.output.titan.storage.index.search.index-name=healthcare|' $FAUNUS_HOME/bin/sequencefile-titan.properties

	sed -i 's|^faunus.graph.output.titan.metrics.ganglia.hostname=.*|faunus.graph.output.titan.metrics.ganglia.hostname=172.17.0.3|' $FAUNUS_HOME/bin/sequencefile-titan.properties
	sed -i 's|^faunus.graph.output.titan.metrics.ganglia.spoof=.*|faunus.graph.output.titan.metrics.ganglia.spoof=172.17.0.3:titan.io|' $FAUNUS_HOME/bin/sequencefile-titan.properties

}

function process_sequencefiles() {

	//hadoop fs -chmod -R 777 npi/output-docgraph-edge/
	# $FAUNUS_HOME/bin/script-sequencefile.properties should be there
	#PART_FILE=part-m-00000
	#sed -i "s|^faunus.input.location=.*|faunus.input.location=npi/output-docgraph-titan/job-1/$PART_FILE|" $FAUNUS_HOME/bin/sequencefile-titan.properties
	
	sed -i "s|^faunus.input.location=.*|faunus.input.location=npi/DocGraph-2012-2013-Days365.csv|" $FAUNUS_HOME/bin/script-sequencefile.properties
	sed -i 's|^faunus.graph.input.script.file=.*|faunus.graph.input.script.file=npi/script-input-docgraph.groovy|' $FAUNUS_HOME/bin/script-sequencefile.properties
	sed -i 's|^faunus.output.location=.*|faunus.output.location=npi/output-docgraph-edge|' $FAUNUS_HOME/bin/script-sequencefile.properties
	sed -i 's|^mapred.job.tracker=.*|mapred.job.tracker=172.17.0.11:9001|' $FAUNUS_HOME/bin/script-sequencefile.properties
	
}

function move_blueprintsfile() {

	# /tmp/faunus/BlueprintsScript.groovy should be there
	chown hdfs.hdfs /tmp/faunus/BlueprintsScript.groovy
	sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/BlueprintsScript.groovy /user/hdfs/npi/BlueprintsScript.groovy
}

function start_job() {

	#echo 'FAUNUS_HOME=/opt/faunus' >> /etc/environment
	
	su - hdfs 
	$FAUNUS_HOME/bin/gremlin.sh
	g = FaunusFactory.open('/opt/faunus/bin/script-sequencefile.properties')
	g = FaunusFactory.open('/opt/faunus/bin/sequencefile-titan.properties')
	g._
}

function process_sequencefiles() {

	# $ screen -X -S [session # you want to kill] quit

	# delete index:
	# curl -XDELETE 'http://172.17.0.7:9200/healthcare/'

	#!/bin/bash

	rm -rf /tmp/faunus/upload.groovy
	echo -e "g = FaunusFactory.open('/opt/faunus/bin/sequencefile-titan.properties');\ng._;\ng.shutdown();\nexit;\n" >> /tmp/faunus/upload.groovy

	rm /tmp/faunus/process_sequencefiles_time

	PARTFILES=($(sudo -u hdfs hadoop fs -ls npi/output-docgraph-titan/job-1 | grep part | awk '{print $8}'))

	STARTTIME=$(date +%s)
	
	for index in ${!PARTFILES[*]}
	do
	    if [ $index -gt 0 ]; then
	      printf "%4d: %s\n" $index ${PARTFILES[$index]}
	      sed -i "s|^faunus.input.location=.*|faunus.input.location=${PARTFILES[$index]}|" $FAUNUS_HOME/bin/sequencefile-titan.properties
	      sudo -E -H -u hdfs bash -c "$FAUNUS_HOME/bin/gremlin.sh < /tmp/faunus/upload.groovy"      
	    fi
	    ENDTIME=$(date +%s)
		echo "$index: $(($ENDTIME - $STARTTIME)) seconds elapsed" >> /tmp/faunus/process_sequencefiles_time
	done

#chmod a+x /tmp/faunus/process_sequencefiles
#nohup /tmp/faunus/process_sequencefiles > /dev/null 2>&1 &

    #${arr[*]}         # All of the items in the array
    #${!arr[*]}        # All of the indexes in the array
    #${#arr[*]}        # Number of items in the array
    #${#arr[0]}        # Length of item zero

}

function copy_to_local() {
	mkdir /tmp/faunus/docgraph_sequencefiles
	sudo -E -H -u hdfs bash -c "hadoop fs -get /user/hdfs/npi/output-docgraph-titan/job-1/part* /tmp/faunus/docgraph_sequencefiles"
}

function concatToLocal() {
	rm /tmp/faunus/docgraph-edges.json
	sudo -u hdfs hadoop fs -getmerge /user/hdfs/npi/output-docgraph-titan/job-1/ /tmp/faunus/docgraph-edges.json
	sudo -u hdfs hadoop fs -copyFromLocal /tmp/faunus/docgraph-edges.json /user/hdfs/npi/docgraph-edges.json
}

function moveDocgraphSequencefilesToHost() {

	BASEDIR=~/NEAT/docker-scripts
	MASTER_IP=172.17.0.11
	chmod 400 $BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa
	scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=$BASEDIR/apache-hadoop-hdfs-precise/files/id_rsa root@${MASTER_IP}:/tmp/faunus/docgraph_sequencefiles/* ~/tmp/docgraph_sequencefiles
}
# sort -t $',' -k 1,1 DocGraph-2012-2013-Days30.csv >DocGraph-2012-2013-Days30_sorted.csv
# sort -t $',' -k 1,1 DocGraph-2012-2013-Days365.csv >DocGraph-2012-2013-Days365_sorted.csv

#############################
## NPI Data
#############################
function download_file() {

	mkdir -p /root/downloads && cd /root/downloads
	wget http://nppes.viva-it.com/NPPES_Data_Dissemination_June_2014.zip
	unzip NPPES_Data_Dissemination_June_2014.zip
	#remove header
	tail -n +2 npidata_20050523-20140608.csv > npidata_20050523-20140608_nohead.csv
	
}

function move_file() {

	chown hdfs.hdfs /root/downloads/npidata_20050523-20140608_nohead.csv
	mv /root/downloads/npidata_20050523-20140608_nohead.csv /tmp/npi.csv 
	sudo -u hdfs hadoop fs -mkdir npi
	sudo -u hdfs hadoop fs -moveFromLocal /tmp/npi.csv /user/hdfs/npi/npi.csv
	cd /root && rm -rf downloads
}

function move_blueprintsfile() {

	# /tmp/faunus/script-input.groovy should be there
	chown hdfs.hdfs /tmp/faunus/script-input.groovy
	sudo -u hdfs hadoop fs -moveFromLocal /tmp/faunus/script-input.groovy /user/hdfs/npi/script-input.groovy

	#Clear cache
	sudo sh -c "sync; echo 3 > /proc/sys/vm/drop_caches"
}
