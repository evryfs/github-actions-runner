#!/usr/bin/env bash
set -e

if [ -z "$RUNNER_TOKEN" ]
then
  echo "Must define RUNNER_TOKEN variable"
  exit 255
fi

if [ -z "$GH_REPO" ]
then
  readonly RUNNER_URL=https://github.com/${GH_ORG}
else
  readonly RUNNER_URL="https://github.com/${GH_ORG}/${GH_REPO}"
fi

RUNNER_TOKEN=${RUNNER_TOKEN:-$(curl -sL -H "Authorization: token ${GH_TOKEN}" -XPOST "${TOKEN_URL}" | jq -r .token)}
./config.sh --unattended --replace --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}" --name "${HOSTNAME}"

unset GH_TOKEN
exec "./run.sh" "${RUNNER_ARGS}"
