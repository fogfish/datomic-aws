## 
## appliance configuration
SYSENV ?= etc/sysenv.yaml

## 
## datomic account
USER ?= none
PASS ?= none
VSN  ?= $(shell cat ${SYSENV} | sed -n "s/Version:[ ]*\([^ ]*\).*/\1/p")
HUB  ?= $(shell cat ${SYSENV} | sed -n "s/Hub:[ ]*\([^ ]*\).*/\1/p")
TEAM ?= $(shell cat ${SYSENV} | sed -n "s/Team:[ ]*\([^ ]*\).*/\1/p")

SEQ  ?=
VER   = $(shell test -z ${SEQ} && echo "${VSN}" || echo "${VSN}-${SEQ}")
URL   = $(shell test -z ${HUB} && echo "${TEAM}/datomic:${VER}" || echo "${HUB}/${TEAM}/datomic:${VER}")
CCURL = $(shell test -z ${HUB} && echo "${TEAM}/cc-datomic:${VER}" || echo "${HUB}/${TEAM}/cc-datomic:${VER}")

setup: src/aws/setup.yaml
	@sh src/scripts/setup.sh -f $^ -c ${SYSENV}

upload: license.txt
	@sh src/scripts/upload-artifacts.sh -u ${USER} -p ${PASS} -v ${VSN} -c ${SYSENV}
	@sh src/scripts/upload-license.sh -f $^ -c ${SYSENV}

resources: src/aws/resources.yaml
	@sh src/scripts/resources.sh -f $^ -c ${SYSENV}

license: 
	@sh src/scripts/config.sh -c ${SYSENV}

docker: src/datomic/Dockerfile src/datomic/scm-source.json
	@U=`sh src/scripts/s3url.sh -c ${SYSENV}` ;\
	docker build --build-arg="PACKAGE_URL=$$U" -t ${URL} -f $< src/datomic/ ;\
	docker tag ${URL} datomic:latest

cc: src/cc/Dockerfile
	@U=`sh src/scripts/s3url.sh -c ${SYSENV}` ;\
	docker build --build-arg="PACKAGE_URL=$$U" -t ${CCURL} -f $< src/cc/

publish:
	docker push ${URL}

src/datomic/scm-source.json: force
	@sh -c '\
		REV=$$(git rev-parse HEAD); \
		URL=$$(git config --get remote.upstream.url || git config --get remote.origin.url); \
		STATUS=$$(git status --porcelain |awk 1 ORS="\\\\\\\\n"); \
		if [ -n "$$STATUS" ]; then REV="$$REV (locally modified)"; fi; \
		echo "{\"url\": \"git:$$URL\", \"revision\": \"$$REV\", \"author\": \"$$USER\", \"status\": \"$$STATUS\"}"' > $@
	
run: src/local.yaml
	docker-compose -f $^ up

dev:
	@sh src/scripts/get-artifacts.sh -c ${SYSENV}

force:

.PHONY: setup upload resources license docker cc run dev force
