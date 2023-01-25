# Docker automatically installs an older version at /usr/local/bin/kubectl
# but we want to point at correct newer version
# Only do this though if the version we want exists
[[ -f "/usr/bin/kubectl" ]] && alias kubectl='/usr/bin/kubectl'

kubesecretdecodetemplate="{{\"-----------------------------------\n\"}}{{.metadata.name}}{{\"\n-----------------------------------\n\"}}{{range \$k,\$v := .data}}{{printf \"%s: \" \$k}}{{if not \$v}}{{\$v}}{{else}}{{\$v | base64decode}}{{end}}{{\"\n\n\"}}{{end}}"
alias decode="kubectl get secret -o go-template='{{if .items}}{{range .items}}$kubesecretdecodetemplate{{\"\n\"}}{{end}}{{else}}$kubesecretdecodetemplate{{end}}'"

alias unseal='kubeseal -o yaml --recovery-unseal --recovery-private-key <(kubectl get secret -n kube-system sealed-secrets-key -o yaml)'

resetk8s(){
  kubectl config use-context dev

  for user in $(kubectl config get-users | tail -n +2); do
    kubectl config set-credentials $user --auth-provider-arg=config-mode=1 --auth-provider-arg=access-token- --auth-provider-arg=expires-in- --auth-provider-arg=expires-on- --auth-provider-arg=refresh-token- > /dev/null
  done
}

generate_crd_role(){
  CRD=`kubectl get crd -o jsonpath='{range .items[*]}{.metadata.name}{","}{end}' | sed 's/,*$//g'`

  kubectl create role custom-resource-edit-role --verb=get,list,watch,create,delete,deletecollection,patch,update --resource=$CRD --dry-run=client -o yaml | \
  kubectl label -f /dev/stdin --dry-run=client rbac.authorization.k8s.io/aggregate-to-admin=true rbac.authorization.k8s.io/aggregate-to-edit=true --local -o yaml > crd-role-edit.yaml

  kubectl create role custom-resource-view-role --verb=get,list,watch --resource=$CRD --dry-run=client -o yaml | \
  kubectl label -f /dev/stdin --dry-run=client rbac.authorization.k8s.io/aggregate-to-view=true --local -o yaml > crd-role-view.yaml
}

alias kn='kubectl -n'
alias ksn='kubectl config set-context --current --namespace'

_get_aks_credentials_in_sub(){
  for id in $(az aks list --subscription $1 --query='[*].id' -o tsv); do
    rg=$(echo $id | sed 's|.*/resourcegroups/\(.*\)/providers/.*|\1|')
    name=$(echo $id | sed 's|.*/managedClusters/\(.*\)|\1|')

    az aks get-credentials --resource-group $rg --name $name --subscription $1
  done
}

get_all_aks_credentials(){
  for sub in $(az account list --all --query='[*].id' -o tsv); do
    _get_aks_credentials_in_sub $sub
  done
}

get_all_eks_credentials(){
  for profile in $(aws_profiles); do
    for region in $(aws ec2 describe-regions --output text | cut -f4); do
      for cluster in $(aws eks list-clusters --region $region --profile $profile | jq '.clusters[]' -r); do
        aws eks update-kubeconfig --name $cluster --region $region --profile $profile

        arn=$(aws eks describe-cluster --name $cluster --region $region --profile $profile | jq -r '.cluster.arn')

        kubectl config set-credentials "${profile}_${region}_${cluster}" \
          --exec-env AWS_PROFILE=$profile \
          --exec-env AWS_REGION=$region \
          --exec-env CLUSTER_NAME=$cluster \
          --exec-command sh \
          --exec-arg '-c' \
          --exec-api-version='client.authentication.k8s.io/v1beta1' \
          --exec-arg='aws --region $AWS_REGION eks get-token --cluster-name $CLUSTER_NAME 2> /dev/null || ( aws sso login > /dev/null && aws --region $AWS_REGION eks get-token --cluster-name $CLUSTER_NAME 2> /dev/null )'

        kubectl config set-context "${profile}_${region}_${cluster}" --cluster=$arn --user="${profile}_${region}_${cluster}"
        kubectl config delete-user $arn || echo --- User $arn already removed
        kubectl config delete-context $arn || echo --- Context $arn already removed
      done
    done
  done
}

copy_s3_to_self(){
  for object in $(aws s3api list-objects --bucket text-content --query 'Contents[].{Key: Key, Size: Size}'); do
     aws s3 cp s3://awsexamplebucket/ s3://awsexamplebucket/ --sse aws:kms --recursive
  done
}

# get_cloud_aks_credentials(){
#
#   SUBS=(
#     'Cloud Operations'
#     'Tricentis Enterprise Cloud'
#     'Tricentis Enterprise Cloud Dev/Test'
#   )
#
#   for sub in $SUBS; do
#     _get_aks_credentials_in_sub $sub
#   done
# }

drain_all_nodes(){
  for node in $(kubectl get pod -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort | uniq); do
    echo "Node: $node"
    instance=$(aws ec2 describe-instances --filters "Name=private-dns-name,Values=$node" | jq -r '.Reservations[0].Instances[0].InstanceId')
    echo "Instance: $instance"
    for asg in $(aws autoscaling describe-auto-scaling-instances --instance-ids "$instance" | jq -r '.AutoScalingInstances[] | .AutoScalingGroupName'); do
      echo "ASG: $asg"
      aws autoscaling detach-instances --instance-ids "$instance" --auto-scaling-group-name "$asg" --no-should-decrement-desired-capacity
      sleep 60
      kubectl drain $node --ignore-daemonsets --delete-emptydir-data && \
      kubectl delete node $node && \
      aws ec2 terminate-instances --instance-ids $instance
    done
  done
}

restart_pods_in_namespace(){                                                                                                                                                                        origin/RND-6777
  [[ "$#" -ne 1 ]] && echo "Exactly one argument (namespace) expected. $# were provided" && return 1
  kubectl get statefulsets --no-headers -n $1 2> /dev/null | cut -d ' ' -f 1 | xargs -I {} kubectl rollout restart statefulsets/{}
  kubectl get deployments --no-headers -n $1 2> /dev/null | cut -d ' ' -f 1 | xargs -I {} kubectl rollout restart deployments/{}
  kubectl get daemonsets --no-headers -n $1 2> /dev/null | cut -d ' ' -f 1 | xargs -I {} kubectl rollout restart daemonsets/{}
}
