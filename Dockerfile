FROM quay.io/evryfs/base-ubuntu:master
ARG RUNNER_ARCHIVE=https://github.com/actions/runner/releases/download/v2.168.0/actions-runner-linux-x64-2.168.0.tar.gz
RUN useradd -mr -d /runner runner && \
  curl -L ${RUNNER_ARCHIVE} | tar xzvC /runner && \
  /runner/bin/installdependencies.sh && \
  apt-get -y install docker.io && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY entrypoint.sh /
WORKDIR /runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
