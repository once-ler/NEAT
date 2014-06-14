#### Deploy the Faunus distributed cluster

<pre>
$ NUMBER_OF_DATANODES=3
$ sudo deploy/deploy_faunus.sh -i htaox/faunus:0.4.4 -w $NUMBER_OF_DATANODES
</pre>

This will (typically) result in the following setup:

<pre>
NAMESERVER                 10.1.0.3
FAUNUS MASTER       10.1.0.4
FAUNUS DATANODE     10.1.0.5
FAUNUS DATANODE     10.1.0.6
FAUNUS DATANODE     10.1.0.7
</pre>

#### Kill the Faunus cluster

<pre>
$ sudo deploy/kill_all.sh faunus
$ sudo deploy/kill_all.sh nameserver
</pre>

#### After Faunus cluster is killed, cleanup
<pre>
$ sudo docker rm `sudo docker ps -a -q`
$ sudo docker images | grep "<none>" | awk '{print $3}' | xargs sudo docker rmi
</pre>

#### Build locally

__Download the scripts__
<pre>
$ git clone -b add-faunus https://github.com/htaox/docker-scripts.git
</pre>

__Change file permissions__
<pre>    
$ cd ~/docker-scripts
$ chmod a+x build/build_all_faunus.sh
$ chmod a+x faunus-0.4.4/build
$ chmod a+x deploy/deploy_faunus.sh
</pre>

__Build__
<pre>    
$ sudo build/build_all_faunus.sh
</pre>

