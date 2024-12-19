move_helm_charts(){
  mkdir temp-helm-migration
  cd temp-helm-migration
  git init
  git_filter_helm_repo infrastructure master "--path argocd/us/west-2/ops/circleci-runner --path-rename argocd/us/west-2/ops/circleci-runner:circleci-runner"

  git fetch origin
  git checkout origin/main -b RND-37931
  git merge origin/infrastructure --no-edit
  wait_for_no_merge_conflict
  git push origin -f HEAD:RND-37931
  git push origin :infrastructure
  cd ..
  rm -rf temp-helm-migration
}

git_filter_helm_repo(){
  git config pull.rebase false
  git remote add $1 git@github.com:hunters-ai/$1.git
  git fetch $1 $2
  git checkout -b $1 $1/$2
  git filter-repo $3 --force

  git remote add origin git@github.com:hunters-ai/helm-charts.git
  git pull origin main --allow-unrelated-histories --no-edit
  git push origin $1
  git remote remove $1
}

wait_for_no_merge_conflict(){
  CONFLICTS=$(git ls-files -u | wc -l)
  while [ "$CONFLICTS" -gt 0 ] ; do
    echo "There is a merge conflict. Sleeping for 10 seconds"
    sleep 10
    CONFLICTS=$(git ls-files -u | wc -l)
  done
}

move_helm_charts