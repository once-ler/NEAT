#### Deploy the HBase fully-distributed cluster

<pre>
$ NUMBER_OF_REGIONSERVERS=3
$ sudo deploy/deploy_hbase.sh -i htaox/hbase:0.94.18 -w $NUMBER_OF_REGIONSERVERS
</pre>

This will (typically) result in the following setup:

<pre>
NAMESERVER         10.1.0.3
HADOOP NAMENODE    10.1.0.4
HBASE MASTER       10.1.0.4
ZOOKEEPER          10.1.0.4
HADOOP DATANODE    10.1.0.5
HBASE REGIONSERVER 10.1.0.5
HADOOP DATANODE    10.1.0.6
HBASE REGIONSERVER 10.1.0.6
HADOOP DATANODE    10.1.0.7
HBASE REGIONSERVER 10.1.0.7
</pre>

#### Kill the HBase cluster

<pre>
$ sudo deploy/kill_all.sh hbase
$ sudo deploy/kill_all.sh nameserver
</pre>

#### After HBase cluster is killed, cleanup
<pre>
$ sudo docker rm `sudo docker ps -a -q`
$ sudo docker images | grep "<none>" | awk '{print $3}' | xargs sudo docker rmi
</pre>

#### Build locally

__Download the scripts__
<pre>
$ git clone -b add-hbase https://github.com/htaox/docker-scripts.git
</pre>

__Change file permissions__
<pre>    
$ cd ~/docker-scripts
$ chmod a+x build/build_all_hbase.sh
$ chmod a+x hbase-0.94.18/build
$ chmod a+x deploy/deploy_hbase.sh
</pre>

__Build__
<pre>    
$ sudo build/build_all_hbase.sh
</pre>

