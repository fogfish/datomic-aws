
echo "==> spawn ddb"
java \
  -Djava.library.path=/usr/local/aws-ddb/DynamoDBLocal_lib \
  -jar /usr/local/aws-ddb/DynamoDBLocal.jar \
  -sharedDb \
  -dbPath /var/lib/aws-ddb/ &


echo "==> config ddb for datomic"
export AWS_ACCESS_KEY_ID="aws-access-key-id"
export AWS_SECRET_ACCESS_KEY="aws-secret-key"

aws dynamodb create-table \
   --table-name datomic \
   --attribute-definitions AttributeName=id,AttributeType=S \
   --key-schema AttributeName=id,KeyType=HASH \
   --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
   --endpoint-url http://localhost:8000 \
   --region aws-region

wait
