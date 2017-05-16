## 
## appliance configuration
SYSENV ?= etc/sysenv.yaml

## 
## datomic account
USER ?=
PASS ?=
VSN  ?= $(shell cat ${SYSENV} | sed -n "s/Version:[ ]*\(.*\)/\1/p")

setup: src/setup.yaml
	@sh src/setup.sh -f $^ -c ${SYSENV}

upload: license.txt
	@sh src/upload-artifacts.sh -u ${USER} -p ${PASS} -v ${VSN}
	@sh src/upload-license.sh -f $^

.PHONY: setup artifact
