##The easiest way to test Tinkerpop3 Gremlin Server.
===================================================

Github REPO can be found [here](https://github.com/htaox/NEAT/tree/master/docker-scripts/gremlin-server-3.0.0).

###5 minute setup
* * *
###Setup variables
============
```hostname=gremlin-server
image_name=htaox/gremlin-server
image_version=3.0.0
```
###Pull the image
===========
```sudo docker pull $image_name:$image_version
```
###Test interactively
=====================
```sudo docker run --rm -i -t -h $hostname $image_name:$image_version /bin/bash
```
###Launch container as daemon
==============================
```sudo docker run -d -h $hostname $image_name:$image_version
```
###Get ip address of container
===============================
```containers=($(sudo docker ps | grep gremlin-server | awk '{print $1}' | tr '\n' ' '))
for i in "${containers[@]}"; do IP=$(sudo docker logs "$i" | grep ^IP=); done
```
###Assign the IP variable
==========================
```eval $IP
```
###Test websocket handshake
=========================
```curl -i -N -vv -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: localhost" -H "Origin: http://localhost" -k "http://$IP:8182"
```
###Test SSH (ie change properties of gremlin-server.yaml, BTW, root password is "gremlin")
============
```ssh root@$IP
example: scp ~/gremlin-server.yaml root@$IP:/opt/gremlin-server/config 
```
###Kill containers
===================
```containers=($(sudo docker ps | grep gremlin-server | awk '{print $1}' | tr '\n' ' '))
for i in "${containers[@]}"; do sudo docker kill "$i"; done
```