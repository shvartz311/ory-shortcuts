wsl.exe --set-default-version 2
wsl.exe --set-default Ubuntu-20.04
wsl.exe --set-version Ubuntu-20.04 2
wsl.exe bash -c "cd ~ && \
git clone https://github.com/jnovick/dotfiles.git && \
cd dotfiles && \
bash install.sh && \
bash install-software.bash"
