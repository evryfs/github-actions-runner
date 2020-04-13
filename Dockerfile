FROM quay.io/evryfs/base-ubuntu:master
ARG RUNNER_ARCHIVE=https://github.com/actions/runner/releases/download/v2.169.0/actions-runner-linux-x64-2.169.0.tar.gz
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN useradd -mr -d /runner runner && \
  curl -sL ${RUNNER_ARCHIVE} | tar xzvC /runner && \
  /runner/bin/installdependencies.sh && \
  apt-get -y --no-install-recommends install lsb-release software-properties-common gnupg-agent && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install docker-ce-cli jq && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY entrypoint.sh /
WORKDIR /runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
