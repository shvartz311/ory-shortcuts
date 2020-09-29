# dotfiles

If anyone wants to use this repo that is not me, please fork it and change `jdnovick` everywhere to your own username.
Also, be sure to change to gitconfig to your own git config, but leave the `credential` section in place.
**NEVER** Commit back sesitive information within any file such as `.ssh` or the `access-token` in `.kube/config`.

## Main setup plan

1. Install WSL by running this in powershell as admin. It comes from [Official MS Docs](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

1. Run powershell file `./powershell/install-prerequisites.ps1` which has automated installing software needed,
   but is untested. If anything fails, fix by hand or use [below instructions](#Set-up-a-little-more-by-hand)
   - ITSO South (Service Desk) is gonna be adding these apps to Software Center/Windows Store. Install from there instead of using this script once that is done.
     - Windows Terminal
     - Ubuntu 20.04
     - WSL2 Kernel Patch
1. Copy windows Terminal settings that you desire from [here](./WindowsTerminalSettings.jsonc).
1. Might still need to install [Cascadia Code](https://docs.microsoft.com/en-us/windows/terminal/cascadia-code) for VS Code.
   It is now included in Windows Terminal though so you won't need it there.
   - Configure VS Code to use correct font `"terminal.integrated.fontFamily": "Cascadia Code PL"`
1. Import `CiscoVPN-Network-Update.xml` as a scheduled task and copy `Cisco.ps1` to `C:\Users\jdnovick\Cisco.ps1`.
   [Relevant GitHub issue](https://github.com/microsoft/WSL/issues/4277#issuecomment-639460712)
1. Login to the new distro once to configure username and password
1. Run powershell file: `./powershell/install-dotfiles-and-software.ps1`
   - When prompted, enter password. This will happen multiple times.
1. Install latest docker: <https://hub.docker.com/editions/community/docker-ce-desktop-windows/>
   - The version in Software Center was too old to have the WSL2 support that I was looking for as of when I wrote this,
     but ITSO South is currently updating it.
1. Configure docker to use WSL2 backend and support the newly set up distro
1. Confirm docker is working with `docker ps`. If there are issues, close and reopen wsl and restart docker. That fixed my issues.

## Set up a little more by hand

If the powershell script above fails, these steps are the manual equivalent

- To get best Windows Terminal experience, I first install these steps by hand:

  1. Run step 1 from above

  1. Download and install kernel update <https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi>
  1. Follow Instructions I wrote when I did upgrade to WSL2 from WSL1: [WSL2 Upgrade Steps](./docs/WSL2UpgradeSteps.md)
     - I have removed any steps that are now automated to set up the dotfiles or install software (Except .ssh folder)

- Clone git repo

  - Clone must happen on linux file system not Windows unless [mount options](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#mount-options)
    have been enabled in `/etc/wsl.conf`. Example settings below, but I recommend still using the linux side.

    ```conf
    [automount]
    options = "metadata,umask=22,fmask=11"
    ```

  - Setup the [git credential manager](https://github.com/microsoft/Git-Credential-Manager-for-Windows/releases) before cloning

    ```bash
    git clone -c credential.helper="/mnt/c/Program\\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe" https://gitlab.infiniteenergy.dev/Jdnovick/dotfiles.git

    # Once the script is run, this will come from global ~/.gitconfig
    # so we are unsetting it here. This is optional to do.
    cd dotfiles && git config --unset credential.helper
    ```

- Install dotfiles

  - This can be re-run many times safely to link new files added to repo
  - If the dotfiles already exist, the script will rename them with `.<Date-Time>.bak` appended to the end

  ```bash
  chmod +x install-dotfiles.bash
  ./install-dotfiles.bash

  # Alternatively, instead of using chmod, you could do:
  bash install-dotfiles.bash
  ```

- Install desired software
  - This will prompt you for your password up to two times and switch default shell to zsh
  - This is not safe to re-run. Manually re-run pieces for updates, but not the whole thing.

```bash
bash ./install-software.bash
```

## Migrating ssh keys

Copy ssh keys to/from `U:\.ssh` drive. First you must mount the drive either permanantly or temporarilly.
Before mounting, we must create a location to mount to with `sudo mkdir /mnt/u`

```bash
# Save keys to U drive
cp $HOME/.ssh/* /mnt/u/.ssh
# If copy fails because the file is not writable, run these
sudo chmod 600 /mnt/u/.ssh/*
sudo chmod 644 /mnt/u/.ssh/*.pub
sudo chmod 644 /mnt/u/.ssh/known_hosts

# Load keys from U drive
cp /mnt/u/.ssh/* $HOME/.ssh
sudo chmod 600 ~/.ssh/*
# These two are optional
sudo chmod 644 ~/.ssh/*.pub
sudo chmod 644 ~/.ssh/known_hosts
```

## Testing script with fresh WSL Distro

1. Run `.\powershell\create-throwaway-distro.ps1`
1. Verify everything looks good.
1. Delete throw away distro: `wsl.exe --unregister ubuntu-throwaway-2004`
