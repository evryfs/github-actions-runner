#!/usr/bin/env bash
set -e
readonly GH_API_ENDPOINT=https://api.github.com

if [ -z "$GH_REPO" ]
then
  # org-level runners: https://github.com/actions/runner/issues/245
  readonly TOKEN_URL=${GH_API_ENDPOINT}/orgs/${GH_ORG}/actions/runners/remove-token
else
  # per repo runner
  readonly TOKEN_URL=${GH_API_ENDPOINT}/repos/${GH_ORG}/${GH_REPO}/actions/runners/remove-token
fi

RUNNER_TOKEN=$(curl -sL -H "Authorization: token ${GH_TOKEN}" -XPOST "${TOKEN_URL}" | jq -r .token)

./config.sh remove --unattended --token "${RUNNER_TOKEN}"
