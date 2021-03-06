# Datomic appliance installation

The appliance installation requires:
 * AWS account
 * [AWS command-line utilities](https://aws.amazon.com/cli/)
 * Valid access right to execute `aws` utility.
 * [yaml2json](https://github.com/bronze1man/yaml2json)
 * [jq](https://stedolan.github.io/jq/)


## Configure appliance

You need to configure [appliance settings at sysenv.yaml](etc/sysenv.yaml) before the appliance deployment. [See settings file](etc/sysenv.yaml) for configuration instructions. Use `SYSENV` option of Makefile to change the default location of system environment configuration.

```
make ... SYSENV=myconfig.yaml
```


## Setup AWS account

The Datomic appliance requires various AWS resources such as KMS, S3 and other. You need to configure/setup AWS only once during the life cycle of the appliance. The appliance provides Cloud Formation [template](src/setup.yaml) and orchestration scripts for this operation. 

Execute the following command. As the result, it creates the Cloud Formation Stack `datomic-artifacts`.
```
make setup
```


## Upload artifacts

The owner of Datomic account shall upload Datomic artifacts and encrypted license into S3 bucket. You need to
1. Obtains artifact(s) download credentials from [your account](https://my.datomic.com/account)
1. Save your Datomic Pro license to `license.txt` file.    

Upload artifacts to S3 bucket. As the result, it provisions required files to S3 bucket in your AWS account.  
```
make upload USER=your@e.mail PASS=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```


## Configure Jenkins build job

You can use Jenkins to orchestrate assembly of Docker container and its provision to private repository.
The appliance supplies a customizable Jenkins pipeline. You can use it as-is in your environments:
1. Create a new Jenkins pipeline job
2. Copy-paste `Jenkins.build` as inline pipeline script    


## Deploy Datomic to AWS

### Provision resources

The deployment procedure of Datomic requires various [AWS resources](http://docs.datomic.com/storage.html): 
* dynamo db tables
* s3 buckets
* iam roles
* cloud watch metrics

The appliance manages these resources using cloud formation template. Use the following command to initiate deployment procedure. Use `SYSENV` option to supply an solution specific configuration file.

```
make resources
``` 



