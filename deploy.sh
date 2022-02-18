#!/usr/bin/env bash

# Set up the private key if we have one.
if [[ -n "$SSH_PRIVATE_KEY" ]]; then
  eval $(ssh-agent -s)
  echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
fi

# Copy known hosts into the SSH config.
mkdir -p ~/.ssh && chmod 0700 ~/.ssh
cat ${GITHUB_ACTION_PATH}/known_hosts >> ~/.ssh/known_hosts

# Authenticate all possible platform.sh hosts.
# USA region.
ssh-keyscan -t rsa -H git.us.platform.sh   >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.us-2.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.us-3.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.us-4.platform.sh >> ~/.ssh/known_hosts

# Europe region.
ssh-keyscan -t rsa -H git.eu.platform.sh   >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.eu-2.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.eu-3.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.eu-4.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.eu-5.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.de-2.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.fr-3.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.fr-4.platform.sh >> ~/.ssh/known_hosts
ssh-keyscan -t rsa -H git.uk-1.platform.sh >> ~/.ssh/known_hosts

# Australia region.
ssh-keyscan -t rsa -H git.au.platform.sh   >> ~/.ssh/known_hosts

# Canada region.
ssh-keyscan -t rsa -H git.ca-1.platform.sh >> ~/.ssh/known_hosts

platform project:set-remote ${PLATFORM_PROJECT_ID}
PLATFORM_OPTS="-vv --activate --target ${GITHUB_REF_NAME}"
if [[ -n "$FORCE_PUSH" ]]; then
  PLATFORM_OPTS="$PLATFORM_OPTS --force"
fi
platform push ${PLATFORM_OPTS}
