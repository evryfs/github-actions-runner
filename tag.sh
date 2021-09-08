#!/bin/bash

VIRTUAL_ENVIRONMENT_VERSION=$(grep "ARG VIRTUAL_ENVIRONMENT_VERSION" -F Dockerfile| cut -d = -f 2 | sed s/\\//-/)
TAG=${VIRTUAL_ENVIRONMENT_VERSION}

git tag "${TAG}"
