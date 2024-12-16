#! /bin/zsh

##temp=/Users/ory.shvartz/generated-templates
#temp=$(mktemp -d -t generated_prometheus_rules)
#
#rm -f error.log
#
#helm template --values values.yaml --values values-custom.yaml --set ruleNamePrefix=generated-rules alerts . > "$temp/all_rules.yaml" 2> >(grep -v 'found symbolic link' | tee -a error.log >&2)
#
#yq -s "\"$temp/\" + .metadata.name" $temp/all_rules.yaml
#rm $temp/all_rules.yaml
#
#for ruleFile in $(ls $temp)
#do
#    yq -i .spec $temp/$ruleFile
#    promtool check rules $temp/$ruleFile 2> >(tee -a error.log >&2) || fail=1
#done
#
#[[ $fail == 1 || -s error.log ]] && exit 1
#
#ls tests | xargs -I "{}" yq -i '.rule_files[0] = (.rule_files[0] // "generated-rules-*")' tests/"{}"
#
#cp tests/test*.yaml $temp
#
#cd $temp
#
#promtool test rules test* 2> >(tee -a $OLDPWD/error.log >&2) | tee -a >(grep FAILED >> $OLDPWD/error.log)
#
#[[ -s $OLDPWD/error.log ]] && exit 1
#
#cd -
#
#rm -R $temp
#
rm -f error.log
rm -rf rules
mkdir -p rules
helm template --values values.yaml --values values-custom.yaml --set ruleNamePrefix="" alerts . > "rules/all_rules.yml" 2> >(grep -v 'found symbolic link' | tee -a error.log >&2)

yq e '. | select(.kind == "PrometheusRule")' rules/all_rules.yml -s '"rules/" + .metadata.name + ".yaml"'

for ruleFile in $(ls rules/*.yaml)
do
  yq -i .spec $ruleFile
done

for ruleFile in $(ls rules/*.yaml)
do
  promtool check rules $ruleFile 2> >(tee -a error.log >&2) || fail=1
done

[[ "$fail" == 1 || -s error.log ]] && exit 1 || echo All Checks Succeeded!

[[ -d tests ]] || (echo No tests/ directory found. Aborting test run. && exit 0)

rm rules/all_rules.yml

for testFile in $(find -L tests -type f -name "*.yaml")
do
  rulesPath=$(echo $testFile | sed "s|\([^/]*\)/|../|g; s|\(.*\)/[^/]*.yaml|\1|g")/rules
  rulesFilePattern=$(echo $testFile | sed "s|\(.*/\)[^/]*.yaml\$|\1|g; s|^tests/||; s|\([^/]*\)/|\1-|g; s/-\$//")'*'

  if [[ $(yq '.rule_files | has(0)' $testFile) == 'false' ]]; then
    echo Defaulting 'rule_files' to [ $rulesPath/$rulesFilePattern ] since no value is specified
    yq -i ".rule_files[0] = \"$rulesPath/$rulesFilePattern\"" $testFile
  fi

  promtool test rules $testFile 2> >(tee -a error.log >&2) | tee -a >(grep FAILED >> error.log) || fail=1
done

[[ "$fail" == 1 || -s error.log ]] && exit 1 || echo All Tests Succeeded!
