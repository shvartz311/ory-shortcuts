# dotfiles

If anyone wants to use this repo that is not me, please fork it and change `joshua` and `josno` everywhere to your own username.
Also, be sure to change to gitconfig to your own git config, but leave the `credential` section in place.
**NEVER** Commit back sesitive information within any file such as `.ssh` or the `access-token` in `.kube/config`.

## Main setup plan

1. Install WSL by running this in powershell as admin. It comes from [Official MS Docs](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

1. In a non-admin powershell, run this command: `wsl --set-default-version 2`
1. Install these apps
   - Windows Terminal
   - Ubuntu
     - If you prefer a different distro, either download from
       [here](https://docs.microsoft.com/en-us/windows/wsl/install-manual)
       or the Microsoft Store
     - Alternatively, you can side-load any `.tar.gz` root file system with `wsl --import`. See test script for example.
   - Windows Subsystem for Linux Update
     ([Available here](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package))
   - Docker
1. Open Ubuntu distro for the first time to set up username and password within distro. This is independent of Windows password but can be set the same.
   - To change your password later, run `passwd`.
1. Copy windows Terminal settings that you desire from [here](./WindowsTerminalSettings.jsonc).
1. Might still need to install [Cascadia Code](https://docs.microsoft.com/en-us/windows/terminal/cascadia-code) for VS Code.
   Docs say it is now included in Windows Terminal so you shouldn't need it there, but my experience was having to manually install it.
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

## Manual instructions for configuring dotfiles

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

2. Install dotfiles

   - This can be re-run many times safely to link new files added to repo
   - If the dotfiles already exist, the script will rename them with `.<Date-Time>.bak` appended to the end

   ```bash
   chmod +x install.sh
   ./install.sh

   # Alternatively, instead of using chmod, you could do:
   bash install.sh
   ```

3. Install desired software
   - This will prompt you for your password up to two times and switch default shell to zsh
   - This is not safe to re-run. Manually re-run pieces for updates, but not the whole thing.

```bash
bash ./install-software.bash
```

## Testing script with fresh WSL Distro

1. Run `.\powershell\create-throwaway-distro.ps1`
1. Verify everything looks good.
1. Delete throw away distro: `wsl.exe --unregister ubuntu-throwaway-2004`
