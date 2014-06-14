#### Deploy the Elasticsearch distributed cluster

<pre>
$ NUMBER_OF_DATANODES=3
$ sudo deploy/deploy_elasticsearch.sh -i htaox/elasticsearch:0.90.13 -w $NUMBER_OF_DATANODES
</pre>

This will (typically) result in the following setup:

<pre>
NAMESERVER                 10.1.0.3
ELASTICSEARCH MASTER       10.1.0.4
ELASTICSEARCH DATANODE     10.1.0.5
ELASTICSEARCH DATANODE     10.1.0.6
ELASTICSEARCH DATANODE     10.1.0.7
</pre>

#### Kill the Elasticsearch cluster

<pre>
$ sudo deploy/kill_all.sh elasticsearch
$ sudo deploy/kill_all.sh nameserver
</pre>

#### After Elasticsearch cluster is killed, cleanup
<pre>
$ sudo docker rm `sudo docker ps -a -q`
$ sudo docker images | grep "<none>" | awk '{print $3}' | xargs sudo docker rmi
</pre>

#### Build locally

__Download the scripts__
<pre>
$ git clone -b add-elasticsearch https://github.com/htaox/docker-scripts.git
</pre>

__Change file permissions__
<pre>    
$ cd ~/docker-scripts
$ chmod a+x build/build_all_elasticsearch.sh
$ chmod a+x elasticsearch-0.90.13/build
$ chmod a+x deploy/deploy_elasticsearch.sh
</pre>

__Build__
<pre>    
$ sudo build/build_all_elasticsearch.sh
</pre>

