# dotfiles

- To get best Windows Terminal experience, I first install these steps by hand:

  1. Install WSL by running this in powershell as admin. [Official MS Docs](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

  ```powershell
  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
  ```

  1. Download and install kernel update <https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi>
  1. Follow Instructions I wrote when I did upgrade to WSL2 from WSL1: [WSL2 Upgrade Steps](./docs/WSL2UpgradeSteps.md)
      - Skip any steps that set up the dotfiles
      - Remove those steps later
      - TODO: Automate and streamline more

- Install dotfiles
  - If the dotfiles already exist, the script will rename them with `.<Date-Time>.bak` appended to the end

``` zsh
chmod +x install.zsh
./install.zsh
```
