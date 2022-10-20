# dotfiles

If anyone wants to use this repo that is not me, please fork it and change `joshua` and `Joshua` everywhere to your own username.
Also, be sure to change to gitconfig to your own git config, but leave the `credential` section in place.
**NEVER** Commit back sesitive information within any file such as `.ssh` or the `access-token` in `.kube/config`.

## Mac Setup instructions

The tools installed for Mac are not the same as those currently configured for Linux/WSL on Windows.
This is because my only use-case for Mac is my company laptop at Hunters so I am only installing tools I may need there.

1. `zsh install-software-mac.sh`
1. `zsh install.sh`
1. Set iTerm2 Font: `https://iterm2.com/documentation-fonts.html`. Either choose a Powerline font or enable the built-in powerline characters.
1. In iTerm2, import the preset colors from `One Half Dark - Joshua.itermcolors`
1. Close the terminal and open iTerm2.

## Debian/Ubuntu Setup instructions

1. `bash install-software.bash`
1. `zsh install.sh`
1. Close and re-open terminal
1. Done! :)

## Main setup plan for WSL on Windows

1. Install WSL by running this in powershell as admin. It comes from [Official MS Docs](https://learn.microsoft.com/en-us/windows/wsl/install)

   ```powershell
   wsl --install
   ```

1. In a non-admin powershell, run this command: `wsl --set-default-version 2`
1. Restart computer
1. Install these apps
   - Windows Terminal and/or Windows Terminal Preview
   - Docker
1. Open Ubuntu distro for the first time to set up username and password within distro. This is independent of Windows password but can be set the same.
   - To change your password later, run `passwd`.
1. Copy windows Terminal settings that you desire from [here](./WindowsTerminalSettings.jsonc).
1. Install [Cascadia Code](https://docs.microsoft.com/en-us/windows/terminal/cascadia-code) so that we can use `Cascadia Code PL` font for the special characters.
1. Configure docker to use WSL2 backend and support the newly set up distro
1. Confirm docker is working with `docker ps`. If there are issues, close and reopen wsl and restart docker. That fixed my issues.
1. Run powershell file: `./powershell/install-dotfiles-and-software.ps1`
   - When prompted, enter password. This will happen multiple times.
   - If this does not work, you can use manual instructions for dotfiles below.
1. To fix VPN issues, use the `vpn` alias in WSL2 while Windows account has admin access. Once disconnected from VPN, run `unvpn` in WSL2 or
   close and re-open it. This could be automated with a scheduled task but this is not supported by the HRB setup.
1. Configure VS Code to desired settings

   ```jsonc
   {
     "terminal.integrated.fontFamily": "Cascadia Code PL",
     "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\wsl.exe",
     "dotfiles.repository": "jnovick/dotfiles",
     "terminal.integrated.shell.linux": "/bin/zsh"
   }
   ```

## Manual instructions for configuring dotfiles on WSL on Windows

If the powershell script above (`./powershell/install-dotfiles-and-software.ps1`) fails, these steps are the manual equivalent

1. Clone git repo inside distro

   - Clone must happen on linux file system not Windows unless [mount options](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#mount-options)
     have been enabled in `/etc/wsl.conf`. Example settings below, but I recommend still using the linux side.

     ```conf
     [automount]
     options = "metadata,umask=22,fmask=11"
     ```

     ```bash
     # You can switch this to ssh later if you choose but until ssh keys are created and added in GitHub, you must use https
     git clone https://github.com/jnovick/dotfiles.git
     ```

1. Install dotfiles

   - This can be re-run many times safely to link new files added to repo
   - If the dotfiles already exist, the script will rename them with `.<Date-Time>.bak` appended to the end

   ```bash
   chmod +x install.sh
   ./install.sh

   # Alternatively, instead of using chmod, you could do:
   bash install.sh
   ```

1. Install desired software
   - This will prompt you for your password up to two times and switch default shell to zsh
   - This is not safe to re-run. Manually re-run pieces for updates, but not the whole thing.

```bash
bash ./install-software.bash
```

## Testing script with fresh WSL Distro

1. Run `.\powershell\create-throwaway-distro.ps1`
1. Verify everything looks good.
1. Delete throw away distro: `wsl.exe --unregister ubuntu-throwaway-2004`
