FROM quay.io/evryfs/base-ubuntu:focal-20220415

# This the release tag of virtual-environments: https://github.com/actions/virtual-environments/releases
ARG UBUNTU_VERSION=2004
ARG VIRTUAL_ENVIRONMENT_VERSION=ubuntu20/20220626.1

ENV UBUNTU_VERSION=${UBUNTU_VERSION} VIRTUAL_ENVIRONMENT_VERSION=${VIRTUAL_ENVIRONMENT_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base packages.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo=1.8.* \
    lsb-release=11.1.* \
    software-properties-common=0.99.* \
    gnupg-agent=2.2.* \
    openssh-client=1:8.* \
    make=4.*\
    rsync \
    wget \
    jq=1.* \
    amazon-ecr-credential-helper=0.3.* && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add sudo rule for runner user
RUN echo "runner ALL= EXEC: NOPASSWD:ALL" >> /etc/sudoers.d/runner

# Update git.
RUN add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get -y install --no-install-recommends git=1:2.36.* && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install docker cli.
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg > /etc/apt/trusted.gpg.d/docker.asc && \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli=5:20.10.* && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy scripts.
COPY scripts/ /usr/local/bin/

# Install additional distro packages and runner virtual envs
ARG VIRTUAL_ENV_PACKAGES=""
ARG VIRTUAL_ENV_INSTALLS="basic python aws azure-cli docker-compose nodejs"
RUN apt-get -y update && \
    ( [ -z "$VIRTUAL_ENV_PACKAGES" ] || apt-get -y --no-install-recommends install $VIRTUAL_ENV_PACKAGES ) && \
    . /usr/local/bin/install-from-virtual-env-helpers && \
    for package in ${VIRTUAL_ENV_INSTALLS}; do \
        install-from-virtual-env $package;  \
    done && \
    apt-get -y install --no-install-recommends gosu=1.* && \
    apt-get -y clean && \
    rm -rf /virtual-environments /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install runner and its dependencies.
RUN groupadd -g 121 runner && useradd -mr -d /home/runner -u 1001 -g 121 runner && \
    install-runner

COPY entrypoint.sh /
WORKDIR /home/runner
USER runner
ENTRYPOINT ["/entrypoint.sh"]
