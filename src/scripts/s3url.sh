#!/bin/bash
## 
## Create pre-signed s3 url for datomic artifacts
set -e
set -u

STACK=datomic-artifacts
while getopts "c:" opt ;
do
   case $opt in
      c)
         CONF=$OPTARG
         ;;
   esac
done

REGION=$(cat ${CONF} | sed -n "s/AWSRegion:[ ]*\(.*\)/\1/p")
S3=$(aws cloudformation describe-stack-resources \
   --stack-name ${STACK} \
   --logical-resource-id ArtifactsS3 \
   --region ${REGION} \
  | jq -r '.StackResources[0].PhysicalResourceId')

aws s3 presign s3://${S3}/datomic-pro/datomic-pro-latest.zip --region ${REGION}
