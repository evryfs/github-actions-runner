#!/bin/bash

RUNNER_VERSION=$(grep "ARG RUNNER_VERSION" -F Dockerfile |cut -d = -f 2)
VIRTUAL_ENVIRONMENT_VERSION=$(grep "ARG VIRTUAL_ENVIRONMENT_VERSION" -F Dockerfile| cut -d = -f 2 | sed s/\\//-/)
TAG=${VIRTUAL_ENVIRONMENT_VERSION}-${RUNNER_VERSION}
UBUNTU_VERSION=ubuntu-$(grep "ARG UBUNTU_VERSION" -F Dockerfile | cut -d = -f 2)

git tag "${TAG}"
git tag -f "${UBUNTU_VERSION}"
