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
   FILE=datomic.license
   AZ=$(curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/placement/availability-zone)
   REGION=$(echo $AZ | sed 's/[a-z]$//')

   aws s3 cp ${S3CONFIG} ${CONFIG} --region ${REGION}
   aws s3 cp ${S3LICENSE} - --region ${REGION} | base64 --decode > ${FILE}
   LICENSE=$(aws kms decrypt --ciphertext-blob fileb://${FILE} --query Plaintext --output text --region ${REGION} | base64 --decode)
   sed -i -e "s|^license-key=.*$|license-key=$LICENSE|" ${CONFIG}
fi

##
echo "==> spawn transactor"
/usr/local/datomic/bin/transactor ${CONFIG}
