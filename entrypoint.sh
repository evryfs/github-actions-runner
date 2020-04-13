#!/bin/bash
set -e

readonly GH_API_ENDPOINT=https://api.github.com
RUNNER_TOKEN=$(curl -sL -H "Authorization: token ${GH_TOKEN}" -XPOST ${GH_API_ENDPOINT}/repos/${GH_ORG}/${GH_REPO}/actions/runners/registration-token| jq -r .token)

REPO_URL=https://github.com/${GH_ORG}/${GH_REPO}
./config.sh --unattended --replace --url ${REPO_URL} --token ${RUNNER_TOKEN}
exec ./run.sh
