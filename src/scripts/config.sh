#!/bin/bash
##
## configure docker environment for RnD
set -e
set -u

STACK=datomic-artifacts

echo "==> decrypt license"
S3=$(aws cloudformation describe-stack-resources \
   --stack-name ${STACK} \
   --logical-resource-id ArtifactsS3 \
  | jq -r '.StackResources[0].PhysicalResourceId')

FILE=datomic.license
aws s3 cp s3://${S3}/${FILE} - | base64 --decode > ${FILE}
LICENSE=$(aws kms decrypt --ciphertext-blob fileb://${FILE} --query Plaintext --output text | base64 --decode)


echo "==> provision datomic config"
CONFIG=$(aws s3 cp s3://${S3}/etc/local.properties - | sed -e "s|^license-key=.*$|license-key=$LICENSE|")

docker run -d -v /etc/datomic --name datomic-config centos bash

docker run -it --rm --volumes-from datomic-config centos bash -c "cat >/etc/datomic/datomic.properties <<EOL
${CONFIG}
EOL"
