#! /bin/bash

BASE_URL=$(git remote get-url origin | sed "s;git@ssh.dev.azure.com:v3/hrblock/TFE;https://dev.azure.com/hrblock/TFE/_git;")
FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD | tail -n 1)
echo "# ${PWD##*/} Changelog" | sed -e "s/\b\(.\)/\u\1/g" > CHANGELOG-temp.md

for TAG in $(git tag -l | tac)
do
  PREVIOUS_TAG=$(git describe --abbrev=0 $TAG^ 2> /dev/null || echo $FIRST_COMMIT)

  if [[ $PREVIOUS_TAG == $FIRST_COMMIT ]]; then
    COMPARE_NAME="the start of the repository"
  else
    COMPARE_NAME=$PREVIOUS_TAG
  fi

  echo >> CHANGELOG-temp.md
  git tag -l --format="## [%(refname:strip=2)]($BASE_URL?version=GT%(refname:strip=2)) %(contents)" $TAG >> CHANGELOG-temp.md
  echo >> CHANGELOG-temp.md

  if [[ $(git cat-file -t $TAG) == "tag" ]]; then
      git tag -l --format="**Date Tagged (Released)**: %(taggerdate:format:%B %d, %Y)" $TAG >> CHANGELOG-temp.md
      echo >> CHANGELOG-temp.md
      git tag -l --format="**Tagged (Released) By**: %(taggername)" $TAG >> CHANGELOG-temp.md
  fi

  printf "\n### Commits between $TAG and $COMPARE_NAME\n\n" >> CHANGELOG-temp.md
  git log --no-merges --pretty="* [%h]($BASE_URL/commit/%H) - %s" $PREVIOUS_TAG..$TAG >> CHANGELOG-temp.md

  PULL_REQUESTS=$(git log --merges --pretty="* %s" $PREVIOUS_TAG..$TAG | grep "Merged PR")
  if [[ $(git log --merges --pretty="* %s" $PREVIOUS_TAG..$TAG | grep "Merged PR") != '' ]]; then
    printf "\n### Pull requests between $TAG and $COMPARE_NAME\n\n" >> CHANGELOG-temp.md
    git log --merges --pretty="* %s" $PREVIOUS_TAG..$TAG | grep "Merged PR" >> CHANGELOG-temp.md
  fi
done

sed -i 's/Merged PR \([0-9]*\)[^0-9].*/!\1/g' CHANGELOG-temp.md
cat -s CHANGELOG-temp.md > CHANGELOG.md
rm CHANGELOG-temp.md
