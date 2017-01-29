#!/bin/bash

set -eux

if [ "${CI_PULL_REQUEST}" == false ] || [ -z "$CI_PULL_REQUEST" ]; then
  echo 'not pull request.'
  exit 0
fi

gem install --no-document checkstyle_filter-git saddler saddler-reporter-github

diffBranchName="origin/develop"
# 変更行のみを対象にする
git diff --name-only --diff-filter=ACMR ${diffBranchName} \
| grep -a '_posts/.*.md$' \
| xargs $(npm bin)/textlint -f checkstyle
