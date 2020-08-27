FROM quay.io/evryfs/base-ubuntu:bionic-20200807

ARG RUNNER_VERSION=2.273.0
ARG COMPOSE_VERSION=1.261.2

# This the release tag of virtual-environments: https://github.com/actions/virtual-environments/releases
ARG VIRTUAL_ENVIRONMENT_VERSION=ubuntu18/20200817.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base packages.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    sudo \
    lsb-release \
    software-properties-common \
    gnupg-agent \
    openssh-client \
    make \
    jq && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install docker cli.
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy scripts.
COPY scripts/install-from-virtual-env /usr/local/bin/install-from-virtual-env
COPY scripts/snap /usr/local/bin/snap

# Install base packages from the virtual environment.
RUN install-from-virtual-env basic
RUN install-from-virtual-env python
RUN install-from-virtual-env aws
RUN install-from-virtual-env docker-compose
RUN install-from-virtual-env nodejs

# Install runner and its dependencies.
RUN useradd -mr -d /home/runner runner && \
    curl -sL "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" | tar xzvC /home/runner && \
    /home/runner/bin/installdependencies.sh

# Clean apt cache.
RUN apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh remove_runner.sh /
WORKDIR /home/runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
