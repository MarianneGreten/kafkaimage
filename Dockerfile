FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

USER root

ENV KFK_HOME=/opt/kafka \
	KFK_DATA=/var/lib/kafka
ENV KFK_CONFIG_DIR=${KFK_HOME}/config

ARG kafka_version=1.0.0
ARG scala_version=2.12

ENV KFK_VERSION=$kafka_version SCALA_VERSION=$scala_version

RUN set -ex; \ 
	curl -o /tmp/kafka.tgz "https://www.apache.org/dist/kafka/${KFK_VERSION}/kafka_${SCALA_VERSION}-${KFK_VERSION}.tgz"; \
    mkdir -p /opt; \
    tar xfz /tmp/kafka.tgz -C /opt; \
    rm /tmp/kafka.tgz; \
    ln -s /opt/kafka_${SCALA_VERSION}-${KFK_VERSION} /opt/kafka

ENV PATH ${PATH}:${KFK_HOME}/bin

# Location for the Kafka data files.
#VOLUME [${KFK_DATA}]

ENV KAFKA_LOG_DIRS=${KFK_DATA}/kafka-logs-

ADD entrypoint.sh /bin/entrypoint.sh

RUN set -ex; \
	chmod +x /bin/entrypoint.sh; \
	mkdir -p $KFK_DATA; \
	chmod a+w $KFK_DATA $KFK_CONFIG_DIR

ENTRYPOINT ["/bin/entrypoint.sh"]

EXPOSE 9092

CMD ["kafka-server-start.sh", "/opt/kafka/config/server.properties"]