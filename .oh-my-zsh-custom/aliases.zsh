alias pip='pip3'
# alias code='code-insiders'
alias dotfiles='code ~/dotfiles/'

jira()
{
  local branch=$(git rev-parse --abbrev-ref HEAD | sed 's;.*/\(.*\);\1;')
  open "https://cyberhunter.atlassian.net/browse/$branch"
}

alias awsr='aws configure set region'

clone(){
  git clone git@github.com:hunters-ai/$1.git
  # git clone $( echo $PWD | sed "s;/Users/ory.shvartz/git/\(.*\);git@github.com:hunters-ai/\1.git;" )/$1 && cd $1;
}

cd()
{
  if [[ -d $1 || $1 == -* || $1 == +* || -z $1 ]]; then
    builtin cd "$@" 2> >(sed 's/cd:[0-9]\+://')
  elif [[ $PWD == '/Users/ory.shvartz/git/'* ]]; then
    clone $1 1>&1 2> /dev/null || builtin cd "$@" 2> >(sed 's/cd:[0-9]\+://')
  else
    builtin cd "$@" 2> >(sed 's/cd:[0-9]\+://')
  fi
}

alias helm2='/opt/homebrew/opt/helm@2/bin/helm'
alias al='aws sso login'
