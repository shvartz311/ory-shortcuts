alias go='cd /c/Users/A1156439/Documents/git/'
vs(){
  explorer.exe *.sln;
  exit 0;
}

# Docker automatically installs an older version at /usr/local/bin/kubectl
# but we want to point at correct newer version
alias kubectl='/usr/bin/kubectl'

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
