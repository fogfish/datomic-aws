#!/bin/bash
##
## setup aws account for datomic appliance
set -e
set -u

STACK=datomic-artifacts

while getopts "f:" opt ;
do
   case $opt in
      f)
         FILE=$OPTARG
         ;;
   esac
done

echo "==> aws cloud formation pending for deployment of ${FILE}"

aws cloudformation create-stack \
   --stack-name ${STACK} \
   --template-body file://${FILE}

aws cloudformation wait stack-create-complete \
   --stack-name ${STACK}
