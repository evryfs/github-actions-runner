#!/bin/bash

RUNNER_VERSION=$(grep "ARG RUNNER_VERSION" -F Dockerfile |cut -d = -f 2)
VIRTUAL_ENVIRONMENT_VERSION=$(grep "ARG VIRTUAL_ENVIRONMENT_VERSION" -F Dockerfile| cut -d = -f 2 | sed s/\\//-/)
TAG=${VIRTUAL_ENVIRONMENT_VERSION}-${RUNNER_VERSION}

git tag "${TAG}"
