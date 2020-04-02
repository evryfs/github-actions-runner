#!/bin/bash
set -e

./config.sh --unattended --replace --url ${REPO_URL} --token ${GH_TOKEN}
exec ./run.sh
