FROM quay.io/evryfs/base-ubuntu:bionic-20200713
ARG RUNNER_VERSION=2.267.1
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN useradd -mr -d /home/runner runner && \
  curl -sL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz | tar xzvC /home/runner && \
  /home/runner/bin/installdependencies.sh && \
  apt-get -y --no-install-recommends install lsb-release software-properties-common gnupg-agent openssh-client && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  add-apt-repository ppa:git-core/ppa && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install docker-ce-cli jq git && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  ln -s /home/runner/externals/node12/bin/node /usr/local/bin/node
RUN curl -sL https://github.com/docker/compose/releases/download/1.25.5/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && chmod a+rx /usr/local/bin/docker-compose
COPY entrypoint.sh remove_runner.sh /
WORKDIR /home/runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
