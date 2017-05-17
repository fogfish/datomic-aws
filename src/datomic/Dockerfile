FROM centos

##
## Install basic utilities, java and python
RUN set -e \
   && yum -y -q update \
   && yum -y -q install java \
   && yum -y -q install zip unzip iproute \
   && yum -y -q install python python-setuptools \
   && easy_install -U pip \
   && pip install --no-cache-dir -U awscli \
   && pip install --no-cache-dir -U kmsclient

##
## Install datomic from S3
ARG PACKAGE_URL=

RUN set -e \
   && curl -o /tmp/datomic-latest.zip "${PACKAGE_URL}" \
   && mkdir -p /etc/datomic \
   && cd /usr/local \
   && unzip -d . /tmp/datomic-latest.zip \
   && ln -s datomic-* datomic \
   && rm /tmp/datomic-latest.zip

EXPOSE 4334

COPY scm-source.json /scm-source.json
COPY run.sh /usr/local/datomic/
ENTRYPOINT ["bash", "/usr/local/datomic/run.sh"]

