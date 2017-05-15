
SYSENV ?= etc/sysenv.yaml

setup: src/setup.yaml
	@sh src/setup.sh -f $^ -c ${SYSENV}

.PHONY: setup
