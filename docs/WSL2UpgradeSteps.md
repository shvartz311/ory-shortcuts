# WSL2 setup after installing Windows 10 2004

* Run this Powershell: `wsl --set-default-version 2`
* Install new WSL 2 distro: <https://docs.microsoft.com/en-us/windows/wsl/install-manual>
  * I chose Ubuntu 20.04
  * I chose to do this instead of updating existing distro to 2 that way I can have new and old side-by-side,
    but the in-place upgrade could have been done with `wsl --set-version Ubuntu-18.04 2`
  * I think I had to do this, but I do not recall: <https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel>
* Set default WSL distro to my new one: `wsl.exe --set-default Ubuntu-20.04`
* Install latest Windows Terminal: [1.2.2234.0](https://github.com/microsoft/terminal/releases/tag/v1.2.2234.0)
  (There are newer versions now)
* Configure Windows Terminal
  * Setup font for old and new distro (Downloaded from [here](https://docs.microsoft.com/en-us/windows/terminal/cascadia-code))
    * Windows Terminal 1.3 ships with Cascadia Code v2008.25 so this step would no longer be necessary
  * Add git bash to Windows Terminal with a unique [GUID](https://www.guidgenerator.com/)
* Configure VS Code to use correct font `"terminal.integrated.fontFamily": "Cascadia Code PL"` since we are going to setup oh-my-zsh later

    ``` json
    {
        "guid": "{4af6d701-26a7-42df-84ba-7dc9f3f0cf3d}",
        "name": "Git bash",
        "commandline": "C:\\Program Files\\Git\\bin\\bash.exe",
        "hidden": false,
        "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico",
        "startingDirectory": "~"
    },
    {
        "guid": "{c6eaf9f4-32a7-5fdc-b5cf-066e8a4b1e40}",
        "hidden": false,
        "name": "Ubuntu-18.04",
        "fontFace": "Cascadia Code PL",
        "source": "Windows.Terminal.Wsl"
    },
    {
        "guid": "{07b52e3e-de2c-5db4-bd2d-ba144ed6c273}",
        "hidden": false,
        "name": "Ubuntu-20.04",
        "fontFace": "Cascadia Code PL",
        "source": "Windows.Terminal.Wsl"
    }
    ```

  * Set default to new Ubuntu distro: `"defaultProfile": "{07b52e3e-de2c-5db4-bd2d-ba144ed6c273}"`

* Run the following Powershell as admin when connected to VPN and WSL is open:
  * I plan on automating the second line using the technique here: <https://github.com/microsoft/WSL/issues/4277#issuecomment-639460712>

```powershell
Get-NetIPInterface -InterfaceAlias "vEthernet (WSL)" | Set-NetIPInterface -InterfaceMetric 1
Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"} | Set-NetIPInterface -InterfaceMetric 6000
```

* Install latest docker: <https://hub.docker.com/editions/community/docker-ce-desktop-windows/>
  * The version in Software Center is too old to have the WSL2 support that I was looking for
* Configure docker to use WSL2 backend and support the newly set up distro
* Confirm docker is working with `docker ps`. If there are issues, close and reopen wsl and restart docker. That fixed my issues.
* I still have my WSL1 distro so I checked the box for "Expose daemon on tcp://localhost:2375 without TLS" since that was needed for WSL1. Don't check that box if you aren't needing WSL1 support.

* Manual steps for adding software and dotfiles have been removed.
  Look in git history for them or use the script in the [README](../README.md).
  * Now is the time to go run those scripts then continue following instructions below.

* Run this stuff in new distro:

``` zsh

# Download certs if you do not already have them or copy from docker-library
# A combined certificate is here, but I copied from docker-library: https://confluence.gainesville.infiniteenergy.com/pages/viewpage.action?pageId=109805577
sudo cp IEIRadius.crt /usr/local/share/ca-certificates/
sudo cp GNVSUBCA1.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

* Run this in the old distro to copy ssh key to Windows where I used to store ssh keys with git bash

``` zsh
cp ~/.ssh/id_ed25519 /c/Users/jdnovick/.ssh/id_ed25519
cp ~/.ssh/id_ed25519.pub /c/Users/jdnovick/.ssh/id_ed25519.pub
# Intentionally choosing not to copy known_hosts since I want to rebuild that file
```

* Run this in new distro

``` zsh
mkdir -m700 ~/.ssh

# Copy old Git Bash keys
cp /c/Users/jdnovick/.ssh/id_rsa ~/.ssh/id_rsa
cp /c/Users/jdnovick/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub

# Copy old distro keys
cp /c/Users/jdnovick/.ssh/id_ed25519.pub ~/.ssh/id_ed25519.pub
cp /c/Users/jdnovick/.ssh/id_ed25519 ~/.ssh/id_ed25519

# Fix permissions on Files
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```
