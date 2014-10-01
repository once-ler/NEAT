##Backing up Docker Containers

To backup (take a snapshot) of all active containers, run the following:

```bash
./backup_all.sh
```

Please note that if an entry exists in /tmp/DOCKER_BACKUP matching **_CONTAINER_ID:HOST_NAME:DATE_**,
the backup will be **SKIPPED**.

```bash
Backing up-> d064174dd7ad:elasticsearch-worker3:172.17.0.10
sudo docker commit d064174dd7ad htaox/elasticsearch-worker3:20141001

Backing up-> e22c4107ff23:elasticsearch-worker2:172.17.0.9
sudo docker commit e22c4107ff23 htaox/elasticsearch-worker2:20141001

Backing up-> bf015a0f095d:elasticsearch-worker1:172.17.0.8
sudo docker commit bf015a0f095d htaox/elasticsearch-worker1:20141001

Backing up-> a6bc7b26ed74:elasticsearch-master:172.17.0.7
sudo docker commit a6bc7b26ed74 htaox/elasticsearch-master:20141001

Backing up-> 8b0d762224b4:hbase-worker3:172.17.0.6
sudo docker commit 8b0d762224b4 htaox/hbase-worker3:20141001

Backing up-> 6f569653b398:hbase-worker2:172.17.0.5
sudo docker commit 6f569653b398 htaox/hbase-worker2:20141001

Backing up-> 4ecd6675e6f3:hbase-worker1:172.17.0.4
sudo docker commit 4ecd6675e6f3 htaox/hbase-worker1:20141001

Backing up-> 7a8b7d479c89:hbase-master:172.17.0.3
sudo docker commit 7a8b7d479c89 htaox/hbase-master:20141001

Backing up-> 4c83f2aa7918:nameserver:172.17.0.2
sudo docker commit 4c83f2aa7918 htaox/nameserver:20141001
```

```bash
$ cat /tmp/DOCKER_BACKUP

d064174dd7ad:elasticsearch-worker3:172.17.0.10
e22c4107ff23:elasticsearch-worker2:172.17.0.9
bf015a0f095d:elasticsearch-worker1:172.17.0.8
a6bc7b26ed74:elasticsearch-master:172.17.0.7
8b0d762224b4:hbase-worker3:172.17.0.6
6f569653b398:hbase-worker2:172.17.0.5
4ecd6675e6f3:hbase-worker1:172.17.0.4
7a8b7d479c89:hbase-master:172.17.0.3
4c83f2aa7918:nameserver:172.17.0.2
```

```bash
$ sudo docker images

REPOSITORY                         TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
htaox/nameserver                   20141001            316e4ba56e2d        3 minutes ago       205.8 MB
htaox/hbase-master                 20141001            e82e9fad6d5d        3 minutes ago       991.8 MB
htaox/hbase-worker1                20141001            d2887870d6ab        3 minutes ago       1.038 GB
htaox/hbase-worker2                20141001            4c885a47f030        5 minutes ago       6.915 GB
htaox/hbase-worker3                20141001            d00af05694a1        6 minutes ago       6.672 GB
htaox/elasticsearch-master         20141001            a833c55e5774        6 minutes ago       923.7 MB
htaox/elasticsearch-worker1        20141001            f7715f662858        9 minutes ago       11.63 GB
htaox/elasticsearch-worker2        20141001            571861378dc8        11 minutes ago      11.11 GB
htaox/elasticsearch-worker3        20141001            8afd67c785e3        15 minutes ago      17.68 GB

```