#!/usr/bin/env bash

# Copy known hosts into the SSH config.
mkdir -p ~/.ssh && chmod 0700 ~/.ssh
cat ${GITHUB_ACTION_PATH}/known_hosts >> ~/.ssh/known_hosts

platform project:set-remote ${PLATFORM_PROJECT_ID}
platform push -vv --activate --force --target ${GITHUB_REF_NAME}
