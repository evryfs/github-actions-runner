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

## Don't re-register on container restart (when data is persisted)
if [ ! -f .credentials ]; then
  ./config.sh --unattended --replace --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}"
fi

unset RUNNER_TOKEN
./run.sh "${RUNNER_ARGS}" || rs=$?

## Currently run.sh doesn't respect runner update (fails immidiately without waiting)
# In this state Return code 3 indicates that the runner update has taken place
# Lookup the latest update log and wait for the succeed log to appear
update_log=$(ls -1t ./_diag/SelfUpdate* | head -1)

if [ $rs -eq 3 ] && [ -n "$update_log" ]; then
  timeout=20
  st=$(date +%s)
  until [ -f "${update_log}.succeed" ]; do
    [[ $((`date +%s` - $st)) -lt $timeout ]] || exit $rs
    sleep 1
  done
else
  exit $rs
fi
