#!/bin/bash

#Back up all active containers (ie snapshot)
#Will use the date as the TAG
CONTAINERS=$(sudo docker ps | awk '{print $1}' | tail -n +2)
DNSMASQ=$(cat $(cat /tmp/DNSMASQ))
MAINTAINER=htaox
TAG=`date +%Y%m%d`
LOGFILE=/tmp/DOCKER_BACKUP

while read CID
do
  # Get IP for each container
  IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CID})
  # Find the corresponding hostname for the IP
  for ENTRY in $DNSMASQ
  do
    MATCH=$(echo $ENTRY | grep $IP)
    if [ ! -z $MATCH ]
    then
      IFS='/' read -ra ADDR <<< "$MATCH"
      #name of running container ie hbase-master, hbase-worker1, etc
      IMAGE="${ADDR[1]}"
      
      COMMIT="${CID}:${ADDR[1]}:${IP}"
      COMMITTED=$(cat $LOGFILE | grep "${COMMIT}")
      if [ ! -z $COMMITED ] || [[ "$COMMITED" =~ ".*No\ such\ file.*" ]]
      then
        echo "Backing up-> ${COMMIT}"
        # log the backup
        echo $COMMIT >> $LOGFILE 
        sudo docker commit "${CID}" "${MAINTAINER}/${IMAGE}:${TAG}"
      else
        echo "Backup already exist-> ${COMMIT}" 
      fi
    fi
  done
done <<<"$CONTAINERS"