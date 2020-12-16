# dotfiles

If anyone wants to use this repo that is not me, please fork it and change `a1156439` everywhere to your own username.
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
   - Configure VS Code to use correct font `"terminal.integrated.fontFamily": "Cascadia Code PL"`
1. I had issues previously with networking in WSL2 while on VPN. The issue seems to have fixed itself so just skip this step and move on.
   If you are having issues though, import `CiscoVPN-Network-Update.xml` as a scheduled task and copy `Cisco.ps1` to `C:\Users\A1156439\Cisco.ps1`.
   [Relevant GitHub issue](https://github.com/microsoft/WSL/issues/4277#issuecomment-639460712)
1. Configure docker to use WSL2 backend and support the newly set up distro
1. Confirm docker is working with `docker ps`. If there are issues, close and reopen wsl and restart docker. That fixed my issues.
1. Run powershell file: `./powershell/install-dotfiles-and-software.ps1`
   - When prompted, enter password. This will happen multiple times.
   - If this does not work, you can use manual instructions for dotfiles below.

## Manual instructions for configuring dotfiles

If the powershell script in the last step above (`./powershell/install-dotfiles-and-software.ps1`) fails, these steps are the manual equivalent

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
   chmod +x install-dotfiles.bash
   ./install-dotfiles.bash

   # Alternatively, instead of using chmod, you could do:
   bash install-dotfiles.bash
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
