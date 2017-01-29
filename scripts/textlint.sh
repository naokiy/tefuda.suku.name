#!/bin/bash

set -eux

if [ "${CI_PULL_REQUEST}" == false ] || [ -z "$CI_PULL_REQUEST" ]; then
  echo 'not pull request.'
  exit 0
fi

gem install --no-document checkstyle_filter-git saddler saddler-reporter-github

diffBranchName="origin/develop"
# 変更行のみを対象にする

DIFF_FILE_COUNT=$(git diff --name-only --diff-filter=ACMR ${diffBranchName} \
| grep -a '_posts/.*.md$' \
| wc -l)

if [ ${DIFF_FILE_COUNT} -eq 0 ]; then
  echo 'no source diff'
  exit 0
fi

git diff --name-only --diff-filter=ACMR ${diffBranchName} \
| grep -a '_posts/.*.md$' \
| xargs $(npm bin)/textlint -f checkstyle \
| checkstyle_filter-git diff ${diffBranchName} \
| saddler report \
    --require saddler/reporter/github \
    --reporter Saddler::Reporter::Github::PullRequestReviewComment
