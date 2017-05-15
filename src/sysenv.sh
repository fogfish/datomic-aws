#!/bin/bash
##
## generate cloud formation stack parameters 
set -e
set -u

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

INPUT=( $(yaml2json < ${FILE} | jq '.Parameters' | jq 'keys' | jq -c -r '.[]') )

for I in "${INPUT[@]}" ; 
do
   sed -n "s|$I:[ ]*\(.*\)|ParameterKey=$I,ParameterValue=\1|p" < ${CONF}
done
