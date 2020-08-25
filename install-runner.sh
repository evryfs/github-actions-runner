#/usr/bin/env bash

set -e
useradd -mr -d /home/runner runner
curl -sL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz | tar xzvC /home/runner
/home/runner/bin/installdependencies.sh
