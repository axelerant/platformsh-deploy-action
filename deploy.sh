#!/usr/bin/env bash

eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null

# Copy known hosts into the SSH config.
mkdir -p ~/.ssh && chmod 0700 ~/.ssh
cat known_hosts >> ~/.ssh/known_hosts

echo "SSH Config"
cat ~/.ssh/config

echo "Existing known_hosts"
cat ~/.ssh/known_hosts

platform project:set-remote ${PLATFORM_PROJECT_ID} -vvv
platform push -vvv --activate --force --target ${GITHUB_REF_NAME}
