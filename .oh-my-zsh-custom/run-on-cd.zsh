#! /usr/bin/zsh

export CURRENT_PROJECT_PATH=$HOME/.current-project

chpwd() {
  # This will allow us to pick up where we left off when a new shell opens
  echo $(pwd) >! $CURRENT_PROJECT_PATH

  # If we are not logged into azure, we cannot automatically set the pulumi config
  az account show > /dev/null 2> /dev/null || return;

  # If we are logged into Azure and we are in a directory with a Pulumi repo, set the config automatically
  case $(pwd) in
    "$HOME/git/cloud/Platform.Ananke/src/SharedResources/Tricentis.Platform.SharedResources" ) set_pulumi_context shared ;;
    "$HOME/git/cloud/Platform.Ananke/src/Spoke/Tricentis.Platform.Spoke" ) set_pulumi_context spoke ;;
    "$HOME/git/cloud/Dex2.Infrastructure/src/E2G.Deployment" ) set_pulumi_context e2g ;;
    "$HOME/git/cloud/Core.Deployment/src/Core.Deployment" ) set_pulumi_context core ;;
    "$HOME/git/cloud/Platform.Spoke/src/Tricentis.Platform.Spoke" ) set_pulumi_context legacy-spoke ;;
    "$HOME/git/cloud/IRIS.Deployment/src/Deployment" ) set_pulumi_context iris ;;
    * ) ;;
  esac
}

# If we recorded a previous location we were working in, cd into it when opening a new shell (or sourcing this file)
if [[ -f $CURRENT_PROJECT_PATH ]]; then
  cd "$(cat $CURRENT_PROJECT_PATH)"
fi
