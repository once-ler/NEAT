### Download NEAT package
*Important: all scripts will rely on location of* <strong>NEAT_HOME</strong>

<pre>
NEAT_HOME=$HOME/NEAT
git clone https://github.com/htaox/NEAT.git $NEAT_HOME
</pre>

### NEAT Package Structure

<pre>
NEAT/
    docker-scripts/
        apache-hadoop-hdfs-precise/
        build/
        deploy/
        dnsmasq-precise/
        elasticsearch-0.90.13/
        faunus-0.4.4/
        hbase-0.94.18/
    projects/
        docgraph/
            config/
            edges/
            setup/
            vertices/
</pre>

### Deploy Distributed Hbase, Elasticsearch, and Faunus clusters with Docker

<pre>
sudo $NEAT_HOME/docker-scripts/deploy/deploy_hbase.sh -i htaox/hbase:0.94.18 -w 3

sudo $NEAT_HOME/docker-scripts/deploy/deploy_elasticsearch.sh -i htaox/elasticsearch:0.90.13 -w 3

sudo $NEAT_HOME/docker-scripts/deploy/deploy_faunus.sh -i htaox/faunus:0.4.4 -w 3
</pre>

The above commands will launch a nameserver, 4 HBase servers, 4 Elasticsearch servers, and 4 Faunus servers.  All servers will automatically be configured, ie Zookeeper, Task/Job Trackers, etc.

*(Depending on your server's power, you may consider launching more or less workers per cluster.)*

You can see the DNS directory file by executing the following:

```
cat $(cat /tmp/DNSMASQ)
```

Typically, it will look like this: 

```
address="/nameserver/172.17.0.2"
address="/hbase-master/172.17.0.3"
address="/hbase-worker1/172.17.0.4"
address="/hbase-worker2/172.17.0.5"
address="/hbase-worker3/172.17.0.6"
address="/elasticsearch-master/172.17.0.7"
address="/elasticsearch-worker1/172.17.0.8"
address="/elasticsearch-worker2/172.17.0.9"
address="/elasticsearch-worker3/172.17.0.10"
address="/faunus-master/172.17.0.11"
address="/faunus-worker1/172.17.0.12"
address="/faunus-worker2/172.17.0.13"
address="/faunus-worker3/172.17.0.14"
```

### Launch the Docgraph edges bulk loading script

Please launch a screen terminal for your session.
```
screen
```

That way, when you exit your ssh session, the processes you launch will continue to run.
```
$NEAT_HOME/projects/docgraph/process_docgraph.sh
```

The bulk load will take a few hours.

### Launch the NPI Registry bulk loading script

```
$NEAT_HOME/projects/docgraph/process_npidata.sh
```

The bulk load will take about half an hour.

