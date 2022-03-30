FROM myoung34/github-runner:2.289.1
ENV YARN_VERSION=1.22.18
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add sudo rule for runner user
RUN echo "runner ALL= EXEC: NOPASSWD:ALL" >> /etc/sudoers.d/runner

# Install libs required for cyress: https://docs.cypress.io/guides/getting-started/installing-cypress#System-requirements
RUN \
    apt-get update && \
    apt-get -y install --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb && \
    apt-get -y clean && \
    rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Add Yarn, as there's currently no setup-yarn action available
RUN	wget -q https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz -O -|tar xzvf - -C /opt && \
	ln -sf /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && \
	ln -sf /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg

# Add runner user with gid 121 and uid 1001, so it is equal to the runner images used by GitHub
RUN groupadd -g 121 runner && useradd -mr -d /actions-runner -u 1001 -g 121 runner

WORKDIR /actions-runner
USER runner
