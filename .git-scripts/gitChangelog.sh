#! /bin/bash

BASE_URL=$(git remote get-url origin | sed "s;git@ssh.dev.azure.com:v3/hrblock/TFE;https://dev.azure.com/hrblock/TFE/_git;")

echo "# Changelog" > CHANGELOG.md

for TAG in $(git tag -l | tac)
do
  echo >> CHANGELOG.md
  PREVIOUS_TAG=$(git describe --abbrev=0 $TAG^ 2> /dev/null || git rev-list --max-parents=0 HEAD | tail -n 1)
  git tag -l --format="## [%(refname:strip=2)]($BASE_URL?version=GT%(refname:strip=2)) - %(contents)" $TAG >> CHANGELOG.md

  printf "\n**Commits**:\n\n" >> CHANGELOG.md
  git log --pretty="* [%h]($BASE_URL/commit/%H) - %s" $PREVIOUS_TAG..$TAG >> CHANGELOG.md
done
