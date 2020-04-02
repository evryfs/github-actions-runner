FROM quay.io/evryfs/base-ubuntu:master
ARG RUNNER_ARCHIVE=https://github.com/actions/runner/releases/download/v2.168.0/actions-runner-linux-x64-2.168.0.tar.gz
RUN useradd -mr -d /runner runner && \
  curl -sL ${RUNNER_ARCHIVE} | tar xzvC /runner && \
  /runner/bin/installdependencies.sh && \
  apt-get -y --no-install-recommends install lsb-release software-properties-common gnupg-agent && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install docker-ce-cli && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY entrypoint.sh /
WORKDIR /runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
