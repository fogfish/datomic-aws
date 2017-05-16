#!/bin/bash
##
## Upload Datomic Pro license to S3
set -e
set -u

STACK=datomic-artifacts
KMSKEY="alias/kms-datomic-license-encryption-key"

while getopts "f:" opt ;
do
   case $opt in
      f)
         FILE=$OPTARG
         ;;
   esac
done

PLAINTEXT=$(cat ${FILE}) 
LICENSE=datomic.license

echo "==> encrypt ${FILE}"
aws kms encrypt --key-id ${KMSKEY} --plaintext ${PLAINTEXT} | jq -r '.CiphertextBlob' > ${LICENSE}

echo "==> lookup for s3"
S3=$(aws cloudformation describe-stack-resources \
   --stack-name ${STACK} \
   --logical-resource-id ArtifactsS3 \
  | jq -r '.StackResources[0].PhysicalResourceId')

echo "==> uploading license to s3://${S3}"
aws s3 cp  ${LICENSE} s3://${S3}/${LICENSE}

