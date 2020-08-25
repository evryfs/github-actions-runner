FROM quay.io/evryfs/base-ubuntu:bionic-20200807
ARG RUNNER_VERSION=2.273.0
ARG COMPOSE_VERSION=1.26.2
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
COPY install*sh /tmp/
RUN /tmp/install-runner.sh && \
  /tmp/install-packages.sh
COPY entrypoint.sh remove_runner.sh /
WORKDIR /home/runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
