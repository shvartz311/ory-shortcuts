#! /usr/bin/zsh

export CURRENT_PROJECT_PATH=$HOME/.current-project

chpwd() {
  # This will allow us to pick up where we left off when a new shell opens
  echo $(pwd) >! $CURRENT_PROJECT_PATH

  # case $(pwd) in
  #   "$HOME/git/infrastructure/terraform/aws/envs/org-hunters/hunters/us-west-2" ) terraform workspace select env0bf6d4d ;;
  #   "$HOME/git/infrastructure/terraform/us-west-2" ) terraform workspace select default ;;
  #   * ) ;;
  # esac

  # If we are in a directory with a Terraform project, initialize the terrafor automatically
  if [[ -f $(pwd)/backend.tf ]]; then
    # Ensure we are logged into AWS
    aws sts get-caller-identity --profile hunters > /dev/null 2> /dev/null || aws sso login

    terraform init
  fi
}

# If we recorded a previous location we were working in, cd into it when opening a new shell (or sourcing this file)
if [[ -f $CURRENT_PROJECT_PATH ]]; then
  cd "$(cat $CURRENT_PROJECT_PATH)"
fi
