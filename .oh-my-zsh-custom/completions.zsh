#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v kubectl &> /dev/null
then
    source <(kubectl completion zsh) # Not sure why kubectl plugin is not already doing this for me
    complete -F __start_kubectl decode
    complete -F __start_kubectl kn
    complete -F __start_kubectl ksn
fi
