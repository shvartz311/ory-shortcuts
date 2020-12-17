#!/bin/bash

# kubectl setup
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
# ~/.kube/config will be set up by install-dotfile.zsh
# Remove version of kubectl installed by docker (I have had to do this a couple more times. I will look for more permanent solution later.)
sudo rm /usr/local/bin/kubectl

# dotnet - https://docs.microsoft.com/en-us/dotnet/core/install/linux#ubuntu
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
# sudo apt-get install -y apt-transport-https && \
# sudo apt-get update
sudo apt-get install -y dotnet-sdk-3.1

# oh-my-zsh - https://ohmyz.sh/
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
# Enter password for changing default shell

# I like mounting at /c instead of /mnt/c and this is part of that setup
sudo sh -c 'echo "$SUDO_USER ALL=(root) NOPASSWD: /bin/mount" >> /etc/sudoers'
sudo mkdir /c
sudo mount --bind /mnt/c /c

# nvm (npm, Node.js, etc.) - https://docs.microsoft.com/en-us/windows/nodejs/setup-on-wsl2#install-nvm-nodejs-and-npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR=/home/$USER/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node
nvm install --lts
npm config set cafile /etc/ssl/certs/ca-certificates.crt -g

# yarn - https://classic.yarnpkg.com/en/docs/install/#debian-stable
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install -y yarn
yarn config set cafile /etc/ssl/certs/ca-certificates.crt -g

# azure-cli - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# terraform (Locking to specific version)
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
# Other terraform versions can be found with apt list -a terraform
sudo apt-get install -y terraform=0.12.29

# Install extra tools
sudo apt-get install -y jq

sudo touch /etc/wsl.conf
sudo bash -c 'cat > /etc/wsl.conf <<_EOF
[automount]
options = "metadata,umask=22,fmask=11"
_EOF'

sudo sh -c 'echo "$SUDO_USER ALL=(root) NOPASSWD: /home/$SUDO_USER/vpn-fix.bash" >> /etc/sudoers'
sudo sh -c 'echo "$SUDO_USER ALL=(root) NOPASSWD: /home/$SUDO_USER/un-vpn-fix.bash" >> /etc/sudoers'

chsh -s /bin/zsh
exec zsh -l
