FROM quay.io/evryfs/base-ubuntu:master
ARG RUNNER_ARCHIVE=https://github.com/actions/runner/releases/download/v2.168.0/actions-runner-linux-x64-2.168.0.tar.gz
RUN useradd -mr -d /runner runner && \
  curl -L ${RUNNER_ARCHIVE} | tar xzvC /runner && \
  /runner/bin/installdependencies.sh
COPY entrypoint.sh /
WORKDIR /runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
