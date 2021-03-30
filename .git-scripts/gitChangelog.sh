#! /bin/bash

BASE_URL=$(git remote get-url origin | sed "s;git@ssh.dev.azure.com:v3/hrblock/TFE;https://dev.azure.com/hrblock/TFE/_git;" | sed "s;https://hrblock@dev;https://dev;")
FIRST_COMMIT=$(git rev-list --max-parents=0 HEAD | tail -n 1)

echo "# ${PWD##*/} Changelog" | sed -e "s/\b\(.\)/\u\1/g" > CHANGELOG-temp.md
echo >> CHANGELOG-temp.md
echo "This file was auto-generated and should not be manually edited" >> CHANGELOG-temp.md

for TAG in $(git tag -l --sort=version:refname | tac)
do
  PREVIOUS_TAG=$(git describe --abbrev=0 $TAG^ 2> /dev/null || echo $FIRST_COMMIT)

  if [[ $PREVIOUS_TAG == $FIRST_COMMIT ]]; then
    COMPARE_NAME="the start of the repository"
  else
    COMPARE_NAME="\`$PREVIOUS_TAG\`"
  fi

  echo >> CHANGELOG-temp.md
  echo >> CHANGELOG-temp.md

  if [[ $(git cat-file -t $TAG) == "tag" ]]; then
    git tag -l --format="## [%(refname:strip=2)]($BASE_URL?version=GT%(refname:strip=2)) %(contents)" $TAG >> CHANGELOG-temp.md
    echo >> CHANGELOG-temp.md
    git tag -l --format="**Date Tagged (Released)**: %(taggerdate:format:%B %d, %Y)" $TAG >> CHANGELOG-temp.md
    echo >> CHANGELOG-temp.md
    git tag -l --format="**Tagged (Released) By**: %(taggername)" $TAG >> CHANGELOG-temp.md
  else
    git tag -l --format="## [%(refname:strip=2)]($BASE_URL?version=GT%(refname:strip=2))" $TAG >> CHANGELOG-temp.md
    echo >> CHANGELOG-temp.md
  fi

  NON_MERGE_COMMITS=$(git log --no-merges --pretty="* [%h]($BASE_URL/commit/%H) - %s" $PREVIOUS_TAG..$TAG)

  FEATURES=$(echo "$NON_MERGE_COMMITS" | grep "\- feat:")
  [[ $FEATURES != '' ]] && printf "\n\n### **New features** added between \`$TAG\` and $COMPARE_NAME\n\n$FEATURES" >> CHANGELOG-temp.md

  FIXES=$(echo "$NON_MERGE_COMMITS" | grep "\- fix:")
  [[ $FIXES != '' ]] && printf "\n\n### **Bugs fixed** between \`$TAG\` and $COMPARE_NAME\n\n$FIXES" >> CHANGELOG-temp.md

  COMMITS=$(echo "$NON_MERGE_COMMITS" | grep -v "\- fix:\|\- feat:")
  [[ $COMMITS != '' && ( $FIXES == '' && $FEATURES == '' ) ]] && printf "\n\n### **Commits** between \`$TAG\` and $COMPARE_NAME\n\n$COMMITS" >> CHANGELOG-temp.md
  [[ $COMMITS != '' && ( $FIXES != '' || $FEATURES != '' ) ]] && printf "\n\n### **Additional commits** between \`$TAG\` and $COMPARE_NAME\n\n$COMMITS" >> CHANGELOG-temp.md

  PULL_REQUESTS=$(git log --merges --pretty="* %s" $PREVIOUS_TAG..$TAG | grep "Merged PR")
  [[ $PULL_REQUESTS != '' ]] && printf "\n\n### **Pull Requests** between \`$TAG\` and $COMPARE_NAME\n\n$PULL_REQUESTS" >> CHANGELOG-temp.md

  # Intentionally adding two spaces after the astrisk instead of one since ADO is not rendering it as a list otherwise.
  WORK_ITEMS=$(git log --pretty="%b" $PREVIOUS_TAG..$TAG | grep -o -E "#[0-9]+" | sort --unique | awk '{print "*  "$1}')
  [[ $WORK_ITEMS != '' ]] && printf "\n\n### **Work Items** between \`$TAG\` and $COMPARE_NAME\n\n$WORK_ITEMS" >> CHANGELOG-temp.md

done

sed -i 's/Merged PR \([0-9]*\)[^0-9].*/!\1/g' CHANGELOG-temp.md
sed -i 's/- feat:/-/g' CHANGELOG-temp.md
sed -i 's/- fix:/-/g' CHANGELOG-temp.md
echo >> CHANGELOG-temp.md
cat -s CHANGELOG-temp.md > CHANGELOG.md
rm CHANGELOG-temp.md
