FROM myoung34/github-runner:2.286.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add sudo rule for runner user
RUN echo "runner ALL= EXEC: NOPASSWD:ALL" >> /etc/sudoers.d/runner

# Update git to remove warnings/errors on path
RUN add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get -y install --no-install-recommends git=1:2.34.* && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add runner user with gid 121 and uid 1001, so it is equal to the runner images used by GitHub
RUN groupadd -g 121 runner && useradd -mr -d /home/runner -u 1001 -g 121 runner

WORKDIR /actions-runner
USER runner
