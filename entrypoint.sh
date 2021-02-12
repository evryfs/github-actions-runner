#!/usr/bin/env bash
set -e

readonly _GH_API_ENDPOINT="${GH_API_ENDPOINT:-https://api.github.com}"

if [ -z "$RUNNER_TOKEN" ]
then
  echo "Must define RUNNER_TOKEN variable"
  exit 255
fi

if [ -z "$GH_REPO" ]
then
  readonly RUNNER_URL=${_GH_API_ENDPOINT}/${GH_ORG}
else
  readonly RUNNER_URL="${_GH_API_ENDPOINT}/${GH_ORG}/${GH_REPO}"
fi

./config.sh --unattended --replace --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}"
exec "./run.sh" "${RUNNER_ARGS}"
