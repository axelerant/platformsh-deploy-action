#!/usr/bin/env bash

# Copy known hosts into the SSH config.
cat known_hosts >> ~/.ssh/known_hosts

eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null

echo "SSH Config"
cat ~/.ssh/config

echo "Existing known_hosts"
cat ~/.ssh/known_hosts

platform project:set-remote ${PLATFORM_PROJECT_ID}
platform push --verbose --activate --force --target ${GITHUB_REF_NAME}
