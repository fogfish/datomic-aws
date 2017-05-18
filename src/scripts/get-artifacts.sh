#!/bin/bash
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

echo "==> lookup for s3"
S3=$(aws cloudformation describe-stack-resources \
   --stack-name ${STACK} \
   --logical-resource-id ArtifactsS3 \
   --region ${REGION} \
  | jq -r '.StackResources[0].PhysicalResourceId')

echo "==> downloading datomic-pro-latest.zip"
aws s3 cp s3://${S3}/datomic-pro/datomic-pro-latest.zip datomic-pro-latest.zip --region ${REGION}
unzip datomic-pro-latest.zip
