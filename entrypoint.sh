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

./config.sh --unattended --replace --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}"
exec "./run.sh" "${RUNNER_ARGS}"
