#!/bin/bash
##
## setup aws account for datomic appliance
set -e
set -u
ROOT=$(dirname $0)
STACK=datomic-artifacts

while getopts "f:c:" opt ;
do
   case $opt in
      f)
         FILE=$OPTARG
         ;;
      c)
         CONF=$OPTARG
         ;;
   esac
done

REGION=$(cat ${CONF} | sed -n "s/AWSRegion:[ ]*\(.*\)/\1/p")

echo "==> cloud formation deployment of ${FILE}"
CONFIG=$(sh ${ROOT}/sysenv.sh -f ${FILE} -c ${CONF})

aws cloudformation create-stack \
   --stack-name ${STACK} \
   --template-body file://${FILE} \
   --parameters ${CONFIG} \
   --region ${REGION}
   

aws cloudformation wait stack-create-complete \
   --stack-name ${STACK} \
   --region ${REGION}
