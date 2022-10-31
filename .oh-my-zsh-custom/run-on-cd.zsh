#! /usr/bin/zsh

export CURRENT_PROJECT_PATH=$HOME/.current-project

chpwd() {
  # This will allow us to pick up where we left off when a new shell opens
  echo $(pwd) >! $CURRENT_PROJECT_PATH

  # If we are in a directory with a Terraform project, initialize the terrafor automatically
  if [[ -f $(pwd)/backend.tf ]]; then
    terraform init

  # Ensure we are logged into AWS
  aws sts get-caller-identity --profile hunters > /dev/null 2> /dev/null || aws sso login
  fi
}

# If we recorded a previous location we were working in, cd into it when opening a new shell (or sourcing this file)
if [[ -f $CURRENT_PROJECT_PATH ]]; then
  cd "$(cat $CURRENT_PROJECT_PATH)"
fi
