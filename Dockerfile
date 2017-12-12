FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

USER root

ENV KAFKA_HOME /opt/kafka \
	KAFKA_DATA=/var/lib/kafka
ENV KAFKA_CONFIG_DIR=${KAFKA_HOME}/config

ARG kafka_version=1.0.0
ARG scala_version=2.12

ENV KAFKA_VERSION=$kafka_version SCALA_VERSION=$scala_version

RUN set -ex; \ 
	&& curl -o /tmp/kafka.tgz "http://www.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
    && mkdir -p /opt \
    && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
    && rm /tmp/kafka.tgz \
    && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka

ENV PATH ${PATH}:${KAFKA_HOME}/bin

# Location for the Kafka data files.
#VOLUME [${KAFKA_DATA}]

ENV KAFKA_LOG_DIRS=${KAFKA_DATA}/kafka-logs-

ADD entrypoint.sh /bin/entrypoint.sh

RUN set -ex; \
	chmod +x /bin/entrypoint.sh; \
	chmod a+w $KAFKA_DATA $KAFKA_CONFIG_DIR

ENTRYPOINT ["/bin/entrypoint.sh"]

EXPOSE 9092

CMD ["kafka-server-start.sh", "/opt/kafka/config/server.properties"]