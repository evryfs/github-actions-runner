FROM myoung34/github-runner:2.296.1
ENV YARN_VERSION=1.22.19
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV RUN_AS_ROOT="false"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add sudo rule for runner user
RUN echo "runner ALL= EXEC: NOPASSWD:ALL" >> /etc/sudoers.d/runner

# Install libs required for cyress: https://docs.cypress.io/guides/getting-started/installing-cypress#System-requirements
RUN \
    apt-get update && \
    apt-get -y install --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb && \
#Add Yarn, as there's currently no setup-yarn action available
  curl -sL https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz |tar xzvf - -C /opt && \
	ln -sf /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && \
	ln -sf /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg && \
  AZ_REPO=$(lsb_release -cs) ; echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
  curl -sL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o /tmp/packages-microsoft-prod.deb && \
  dpkg -i /tmp/packages-microsoft-prod.deb && \
  rm /tmp/packages-microsoft-prod.deb && \
  apt-get update && apt-get -y --no-install-recommends install azure-cli powershell && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /actions-runner
USER runner
