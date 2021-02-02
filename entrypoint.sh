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

## We try to mitigate https://github.community/t/how-to-run-multiple-self-hosted-runners-on-a-single-host/130474Race
work_dir=$(mktemp -du -p .)
work_dir="_work${work_dir#./tmp}"

./config.sh --unattended --replace --url "${RUNNER_URL}" --work "${work_dir}" --token "${RUNNER_TOKEN}"
exec "./run.sh" --work "${work_dir}" "${RUNNER_ARGS}"
