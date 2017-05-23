##
## Container Compiler
##   a helper tool-chain to assembler datomic peer application inside docker container
FROM centos

##
## Install basic utilities, java and python
RUN set -e \
   && yum -y -q update \
   && yum -y -q install zip unzip \
   && yum -y -q install java maven make \
   && curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo \
   && yum -y -q install sbt \
   && sbt about

##
## Install datomic from S3
ARG PACKAGE_URL=

RUN set -e \
   && curl -o /tmp/datomic-latest.zip "${PACKAGE_URL}" \
   && mkdir -p /etc/datomic \
   && cd /usr/local \
   && unzip -d . /tmp/datomic-latest.zip \
   && ln -s datomic-* datomic \
   && rm /tmp/datomic-latest.zip \
   && cd /usr/local/datomic \
   && bin/maven-install

COPY run.sh /run.sh
RUN  chmod +x run.sh
ENTRYPOINT ["/run.sh"]
