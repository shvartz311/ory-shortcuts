wsl.exe --set-default-version 2
wsl.exe --set-default Ubuntu
wsl.exe --set-version Ubuntu 2
wsl.exe bash -c "cd ~ && \
git clone https://github.com/jnovick/dotfiles.git && \
cd dotfiles && \
bash install.sh && \
bash install-software.bash"
