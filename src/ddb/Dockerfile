FROM centos

RUN set -e \
   && yum -y -q update \
   && yum -y -q install java

RUN set -e \
   && mkdir /usr/local/aws-ddb \
   && cd /usr/local/aws-ddb \
   && curl -L -O http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz \
   && tar -xvf dynamodb_local_latest.tar.gz \
   && rm dynamodb_local_latest.tar.gz

RUN set -e \
   && mkdir /var/lib/aws-ddb 

EXPOSE 8000

ENTRYPOINT [ \
   "java" \
  ,"-Djava.library.path=/usr/local/aws-ddb/DynamoDBLocal_lib" \
  ,"-jar", "/usr/local/aws-ddb/DynamoDBLocal.jar" \
  ,"-sharedDb" \
  ,"-dbPath", "/var/lib/aws-ddb/" \
]


