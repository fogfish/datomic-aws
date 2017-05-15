

setup: src/setup.yaml
	@sh src/setup.sh -f $^

.PHONY: setup