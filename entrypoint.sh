#!/bin/bash
set -e
readonly GH_API_ENDPOINT=https://api.github.com

removeRunner() {
  echo "Performing unattended remove of runner..."
  ./config.sh remove --unattended
}

RUNNER_TOKEN=${RUNNER_TOKEN:-$(curl -sL -H "Authorization: token ${GH_TOKEN}" -XPOST "${GH_API_ENDPOINT}/repos/${GH_ORG}/${GH_REPO}/actions/runners/registration-token"| jq -r .token)}
RUNNER_URL=${RUNNER_URL-$([[ -z "$GH_REPO" ]] && echo "https://github.com/${GH_ORG}/${GH_REPO}" || echo "https://github.com/${GH_ORG}" )}
./config.sh --unattended --replace --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}"

trap 'removeRunner' QUIT TERM

RUNNER_ARGS="--once"
exec "./run.sh" "${RUNNER_ARGS}"
