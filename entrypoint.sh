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
./config.sh --unattended --replace --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}"

## We try to mitigate https://github.community/t/how-to-run-multiple-self-hosted-runners-on-a-single-host/130474Race
work_dir=$(mktemp -du -p .)
work_dir="_work${work_dir#./tmp}"

unset GH_TOKEN
exec "./run.sh" --work "$work_dir" "${RUNNER_ARGS}"
