# Datomic appliance installation

The appliance installation requires:
 * AWS account
 * [AWS command-line utilities](https://aws.amazon.com/cli/)
 * Valid access right to execute `aws` utility.


## Configure AWS account

The Datomic appliance requires various AWS resources such as KMS, S3 and other. You need to configure/setup AWS only once during the life cycle of the appliance. The appliance provides Cloud Formation [template](src/setup.yaml) and orchestration scripts for this operation. 

Execute the following command. As the result, it creates the Cloud Formation Stack `datomic-artifacts`.
```
make setup
```
