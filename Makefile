## 
## appliance configuration
SYSENV ?= etc/sysenv.yaml

## 
## datomic account
USER ?= none
PASS ?= none
VSN  ?= $(shell cat ${SYSENV} | sed -n "s/Version:[ ]*\(.*\)/\1/p")

setup: src/aws/setup.yaml
	@sh src/scripts/setup.sh -f $^ -c ${SYSENV}

upload: license.txt
	@sh src/scripts/upload-artifacts.sh -u ${USER} -p ${PASS} -v ${VSN}
	@sh src/scripts/upload-license.sh -f $^

resources: src/aws/resources.yaml
	@sh src/scripts/resources.sh -f $^ -c ${SYSENV}

license: 
	@sh src/scripts/config.sh

docker: src/datomic/Dockerfile
	@U=`sh src/scripts/s3url.sh` ;\
	docker build --build-arg="PACKAGE_URL=$$U" -t datomic:${VSN} -f $^ src/datomic/

run: src/local.yaml
	docker-compose -f $^ up

.PHONY: setup upload resources license docker run
