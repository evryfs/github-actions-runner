#!/bin/bash

RUNNER_VERSION=$(fgrep "ARG RUNNER_VERSION" Dockerfile |cut -d = -f 2)
VIRTUAL_ENVIRONMENT_VERSION=$(fgrep "ARG VIRTUAL_ENVIRONMENT_VERSION" Dockerfile| cut -d = -f 2 | sed s/\\//-/)
TAG=${VIRTUAL_ENVIRONMENT_VERSION}-${RUNNER_VERSION}

git tag ${TAG}
