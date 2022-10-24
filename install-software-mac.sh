#!/bin/zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"

brew install --cask iterm2
# Not needed since zsh is default on Mac
# brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

# Install good utilities
brew install tmux
brew install jq
brew install yq

# Install Kubernetes, Docker, and Helm
brew install kubectl
brew install helm
brew install --cask docker

# Install Python 3
brew install python3
brew install ipython
brew install pipenv

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
installer -pkg AWSCLIV2.pkg \
  -target CurrentUserHomeDirectory \
  -applyChoiceChangesXML $HOME/dotfiles/aws-choices.xml

sudo ln -s $HOME/aws-cli/aws /usr/local/bin/aws
sudo ln -s $HOME/aws-cli/aws_completer /usr/local/bin/aws_completer

which aws
aws --version

brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Configure powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# iTerm2 integration: https://iterm2.com/documentation-shell-integration.html
curl -L https://iterm2.com/shell_integration/zsh \
  -o ~/.iterm2_shell_integration.zsh
