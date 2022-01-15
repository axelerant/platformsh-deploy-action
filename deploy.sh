#!/usr/bin/env bash

eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
platform project:set-remote ${PLATFORM_PROJECT_ID}
platform push --verbose --activate --force --target ${GITHUB_REF_NAME}
