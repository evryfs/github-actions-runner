#/usr/bin/env bash

set -e

cd /tmp

apt-get -y --no-install-recommends install lsb-release software-properties-common gnupg-agent openssh-client make

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
add-apt-repository ppa:git-core/ppa
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get -y update
apt-get -y --no-install-recommends install docker-ce-cli jq git yarn
curl -sL https://deb.nodesource.com/setup_12.x | bash
ln -s /home/runner/externals/node12/bin/node /usr/local/bin/node

curl -sL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose && chmod a+rx /usr/local/bin/docker-compose

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

apt-get -y clean
rm -rf /var/cache/apt /var/lib/apt/lists/* /tmp/* /var/tmp/*
