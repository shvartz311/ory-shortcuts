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
brew install watch

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

#brew tap hashicorp/tap
#brew install hashicorp/tap/terraform
brew install tfenv

# Configure powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# iTerm2 integration: https://iterm2.com/documentation-shell-integration.html
curl -L https://iterm2.com/shell_integration/zsh \
  -o ~/.iterm2_shell_integration.zsh

# Custom operator tooling
brew install operator-sdk

brew install argocd

# GNU tools
brew install gsed
brew install coreutils
brew install gnu-getopt

# Prometheus tools (promtool and promruval)
brew install prometheus
export PATH="${HOME}/.local/bin:$PATH"
VERSION=$(curl -Ls https://api.github.com/repos/FUSAKLA/promruval/releases/latest | jq ".tag_name" | xargs | cut -c2-)                                                                                                                                        origin/RND-6897
echo "https://github.com/FUSAKLA/promruval/releases/download/v${VERSION}/promruval_${VERSION}_linux_386.tar.gz"
wget -qO- "https://github.com/FUSAKLA/promruval/releases/download/v${VERSION}/promruval_${VERSION}_linux_386.tar.gz" \
  | tar xvzf - promruval
mv promruval "${HOME}/.local/bin"/promruval

sh -c "$(curl -sSL https://git.io/install-kubent)"

# Install Krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
