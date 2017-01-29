#!/bin/bash

if [ "${TRAVIS_PULL_REQUEST}" == false ] || [ -z "$TRAVIS_PULL_REQUEST" ]; then
  echo 'not pull request.'
  exit 0
fi

diffBranchName="origin/develop"

git diff --name-only --diff-filter=ACMR ${diffBranchName} \
| grep -a '_posts/.*.md$' \
| xargs $(npm bin)/textlint
