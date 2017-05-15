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
