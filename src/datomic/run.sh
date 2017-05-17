#!/bin/bash

echo "==> booting ..."
CONFIG="/etc/datomic/datomic.properties"


##
echo "==> discovering host ..."
HOST=$(curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/local-hostname)
if [[ -z "${HOST}" ]] ;
then
   # service is not running at aws
   HOST=$({ ip addr show eth0 | sed -n 's/.*inet \([0-9]*.[0-9]*.[0-9]*.[0-9]*\).*/\1/p' ; } || echo "127.0.0.1")
   
   export AWS_ACCESS_KEY_ID="aws-access-key-id"
   export AWS_SECRET_ACCESS_KEY="aws-secret-key"
   echo "${HOST}  docker" > /etc/hosts
fi
echo "==> running at ${HOST}"


##
echo "==> configure service"
if [[ ! -f ${CONFIG} ]] ;
then
   echo "==> no config"
fi


##
echo "==> spawn transactor"
/usr/local/datomic/bin/transactor ${CONFIG}
