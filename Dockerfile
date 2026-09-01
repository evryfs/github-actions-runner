FROM myoung34/github-runner:2.337.0-ubuntu-jammy
ENV YARN_VERSION=1.22.19
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV RUN_AS_ROOT="false"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add sudo rule for runner user
RUN echo "runner ALL= EXEC: NOPASSWD:ALL" >> /etc/sudoers.d/runner

# Install libs required for cyress: https://docs.cypress.io/guides/getting-started/installing-cypress#System-requirements
RUN \
#    apt-get update && \
#    apt-get -y install --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libxtst6 xauth xvfb zip && \
#Add Yarn, as there's currently no setup-yarn action available
  curl -sL https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz |tar xzvf - -C /opt && \
	ln -sf /opt/yarn-v${YARN_VERSION}/bin/yarn /usr/local/bin/yarn && \
	ln -sf /opt/yarn-v${YARN_VERSION}/bin/yarnpkg /usr/local/bin/yarnpkg && \
#  AZ_REPO=$(lsb_release -cs) ; echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
#  curl -sL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o /tmp/packages-microsoft-prod.deb && \
#  dpkg -i /tmp/packages-microsoft-prod.deb && \
#  rm /tmp/packages-microsoft-prod.deb && \
#  apt-get update && apt-get -y --no-install-recommends install azure-cli powershell strace && \
  apt-get update && apt-get -y --no-install-recommends install strace fontconfig curl gcc build-essential git wget vim && \
  apt-get -y clean && \
  rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
#FIPS
RUN wget https://github.com/openssl/openssl/releases/download/openssl-3.5.8/openssl-3.5.8.tar.gz && tar -xzvf openssl-3.5.8.tar.gz

RUN cd openssl-3.5.8 && ./config enable-fips enable-ssl-trace && make -j`nproc` && make install
ENV LD_LIBRARY_PATH=/usr/local/lib/:/usr/local/lib64/
RUN openssl fipsinstall -out /usr/local/ssl/fipsmodule.cnf -module /usr/local/lib64/ossl-modules/fips.so

RUN rm /usr/local/ssl/openssl.cnf

RUN echo -e "openssl_conf = openssl_init \n\
\n\
.include /usr/local/ssl/fipsmodule.cnf \n\
\n\
[openssl_init] \n\
providers = provider_sect \n\
alg_section = algorithm_sect \n\
\n\
[provider_sect] \n\
fips = fips_sect \n\
base = base_sect \n\
\n\
[base_sect] \n\
activate = 1 \n\
\n\
[algorithm_sect] \n\
default_properties = fips=yes" > /usr/local/ssl/openssl.cnf

RUN ln -s /etc/ssl/certs/ca-certificates.crt /usr/local/ssl/cert.pem


WORKDIR /actions-runner
USER runner
