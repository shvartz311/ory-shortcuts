#! /usr/bin/zsh

export CURRENT_PROJECT_PATH=$HOME/.current-project

chpwd() {
  # This will allow us to pick up where we left off when a new shell opens
  echo $(pwd) >! $CURRENT_PROJECT_PATH

  # If we are not logged into azure, we cannot automatically set the pulumi config
  az account show > /dev/null 2> /dev/null || return;

  # If we are logged into Azure and we are in a directory with a Pulumi repo, set the config automatically
  case $(pwd) in
    "$HOME/git/cloud/Platform.Ananke/src/Network/Tricentis.Platform.Hub" ) set_pulumi_context hub ;;
    "$HOME/git/cloud/Platform.Ananke/src/Network/Tricentis.Platform.Wan" ) set_pulumi_context wan ;;
    "$HOME/git/cloud/Platform.Ananke/src/SharedResources/Tricentis.Platform.SharedResources" ) set_pulumi_context shared ;;
    "$HOME/git/cloud/Platform.Ananke/src/Spoke/Tricentis.Platform.Spoke" ) set_pulumi_context spoke ;;
    "$HOME/git/cloud/Dex2.Infrastructure/src/E2G.Deployment" ) set_pulumi_context e2g ;;
    "$HOME/git/cloud/Core.Deployment/src/Core.Deployment" ) set_pulumi_context core ;;
    "$HOME/git/cloud/Core.Deployment/src/Core.Deployment.Global" ) set_pulumi_context core-global ;;
    "$HOME/git/cloud/Platform.Spoke/src/Tricentis.Platform.Spoke" ) set_pulumi_context legacy-spoke ;;
    "$HOME/git/cloud/IRIS.Deployment/src/Deployment" ) set_pulumi_context iris ;;
    "$HOME/git/cloud/Inventory.Deployment/Inventory.Deployment.Spoke" ) set_pulumi_context inventory ;;
    "$HOME/git/cloud/Traviata.PlaylistService.Deployment/Traviata.PlaylistService.Deployment.Spoke" ) set_pulumi_context playlist ;;
    "$HOME/git/cloud/ExampleService.Infrastructure/ExampleService.Infrastructure.Spoke" ) set_pulumi_context exp ;;
    "$HOME/git/QAS-Labs/cloud-operations/iac-state/ananke" ) set_pulumi_context --password '' --local ;;
    * ) ;;
  esac
}

# If we recorded a previous location we were working in, cd into it when opening a new shell (or sourcing this file)
if [[ -f $CURRENT_PROJECT_PATH ]]; then
  cd "$(cat $CURRENT_PROJECT_PATH)"
fi
