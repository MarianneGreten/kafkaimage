
FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift

USER root

ARG chisel_version=1.2.3

ENV CHISEL_VERSION=${chisel_version}

RUN set -ex; \ 
	curl -o /tmp/chisel.gz -L "https://github.com/jpillora/chisel/releases/download/${CHISEL_VERSION}/chisel_linux_amd64.gz"; \
    gunzip -c /tmp/chisel.gz > /usr/local/bin/chisel; \
    rm /tmp/chisel.gz; \
    chmod +x /usr/local/bin/chisel

EXPOSE 8080

CMD ["/usr/local/bin/chisel", "server", "-v", "--host", "0.0.0.0", "--port", "8080"]