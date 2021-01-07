vs(){
  explorer.exe *.sln;
  exit 0;
}

# Docker automatically installs an older version at /usr/local/bin/kubectl
# but we want to point at correct newer version
# Only do this though if the version we want exists
[[ -d "/usr/bin/kubectl" ]] && alias kubectl='/usr/bin/kubectl'

kubesecretdecodetemplate="{{\"-----------------------------------\n\"}}{{.metadata.name}}{{\"\n-----------------------------------\n\"}}{{range \$k,\$v := .data}}{{printf \"%s: \" \$k}}{{if not \$v}}{{\$v}}{{else}}{{\$v | base64decode}}{{end}}{{\"\n\n\"}}{{end}}"
alias decode="kubectl get secret -o go-template='{{if .items}}{{range .items}}$kubesecretdecodetemplate{{\"\n\"}}{{end}}{{else}}$kubesecretdecodetemplate{{end}}'"

alias unseal='kubeseal -o yaml --recovery-unseal --recovery-private-key <(kubectl get secret -n kube-system sealed-secrets-key -o yaml)'

resetk8s(){
  kubectl config use-context dev
  kubectl config set-credentials aks --auth-provider-arg=config-mode=1 --auth-provider-arg=access-token-
  kubectl config set-credentials AZDevKubernetes1 --auth-provider-arg=config-mode=0 --auth-provider-arg=access-token-
}

alias kn='kubectl -n'

alias vpn='sudo ~/vpn-fix.bash'
alias unvpn='sudo ~/un-vpn-fix.bash'

alias pip='pip3'

clone(){
  git clone $( echo $PWD | sed "s;/home/a1156439/git/;git@ssh.dev.azure.com:v3/hrblock/;" )/$1 && cd $1;
}

cd()
{
  if [[ -d $1 || $1 == -* || $1 == +* || -z $1 ]]; then
    builtin cd "$@" 2> >(sed 's/cd:[0-9]\+://')
  elif [[ $PWD == '/home/a1156439/git/'* ]]; then
    clone $1 1>&1 2> /dev/null || builtin cd "$@" 2> >(sed 's/cd:[0-9]\+://')
  else
    builtin cd "$@" 2> >(sed 's/cd:[0-9]\+://')
  fi
}
