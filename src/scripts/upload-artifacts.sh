#!/bin/bash
##
## Upload artifacts to S3 bucket
set -e
set -u

STACK=datomic-artifacts

while getopts "u:p:v:" opt ;
do
   case $opt in
      u)
         USER=$OPTARG
         ;;
      p)
         PASS=$OPTARG
         ;;
      v)
         VSN=$OPTARG
         ;;
   esac
done

PACKAGE=datomic-pro-${VSN}.zip

if [[ ! -f ${PACKAGE} ]] ;
then
   echo "==> downloading package ${PACKAGE}"
   curl -u ${USER}:${PASS} \
      -SL -o ${PACKAGE} \
      https://my.datomic.com/repo/com/datomic/datomic-pro/${VSN}/${PACKAGE}
fi

echo "==> lookup for s3"
S3=$(aws cloudformation describe-stack-resources \
   --stack-name ${STACK} \
   --logical-resource-id ArtifactsS3 \
  | jq -r '.StackResources[0].PhysicalResourceId')

echo "==> uploading ${PACKAGE} to s3://${S3}"
aws s3 cp ${PACKAGE} s3://${S3}/datomic-pro/${PACKAGE}
aws s3 cp ${PACKAGE} s3://${S3}/datomic-pro/datomic-pro-latest.zip

echo "==> uploading config to s3://${S3}"
aws s3 cp etc/*.properties s3://${S3}/etc/

