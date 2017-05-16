#!/bin/bash
##
## provision aws resources required for datomic deployment
set -e
set -u
ROOT=$(dirname $0)

while getopts "i:f:c:" opt ;
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

ENV=$(cat ${CONF} | sed -n "s/Env:[ ]*\(.*\)/\1/p")
SOLUTION=$(cat ${CONF} | sed -n "s/Solution:[ ]*\(.*\)/\1/p")
STACK="${ENV}-datomic-resources-${SOLUTION}"

echo "==> cloud formation deployment of ${FILE}"
CONFIG=$(sh ${ROOT}/sysenv.sh -f ${FILE} -c ${CONF})

aws cloudformation create-stack \
   --stack-name ${STACK} \
   --template-body file://${FILE} \
   --capabilities CAPABILITY_NAMED_IAM \
   --parameters ${CONFIG}

aws cloudformation wait stack-create-complete \
   --stack-name ${STACK}
