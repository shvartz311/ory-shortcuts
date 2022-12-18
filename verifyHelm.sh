#! /bin/bash -eo pipefail

for application in $(find -L tests -type f -name "*.yaml")
do
  rulesPath=$(echo $testFile | sed "s|\([^/]*\)/|../|g; s|\(.*\)/[^/]*.yaml|\1|g")/rules
  rulesFilePattern=$(echo $testFile | sed "s|\(.*/\)[^/]*.yaml\$|\1|g; s|^tests/||; s|\([^/]*\)/|\1-|g; s/-\$//")'*'

  if [[ $(yq '.rule_files | has(0)' $testFile) == 'false' ]]; then
    echo Defaulting 'rule_files' to [ $rulesPath/$rulesFilePattern ] since no value is specified
    yq -i ".rule_files[0] = \"$rulesPath/$rulesFilePattern\"" $testFile
  fi

  promtool test rules $testFile 2> >(tee -a error.log >&2) | tee -a >(grep FAILED >> error.log) || fail=1
done
