$terminal="C:\Users\jdnovick\Downloads\Microsoft.WindowsTerminalPreview_1.4.2652.0_8wekyb3d8bbwe.msixbundle"
$app="C:\Users\jdnovick\Downloads\Ubuntu_2004.2020.424.0_x64.appx"
$kernelUpdate="C:\Users\jdnovick\Downloads\wsl_update_x64.msi"
$user="jdnovick"

if (!(Test-Path $kernelUpdate)) {
  Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile $kernelUpdate
}

if (!(Test-Path $terminal)) {
  Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.4.2652.0/Microsoft.WindowsTerminalPreview_1.4.2652.0_8wekyb3d8bbwe.msixbundle -OutFile $terminal
}

if (!(Test-Path $app)) {
  Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile $app
}

Install-Package $kernelUpdate
Add-AppPackage -Path $terminal
Add-AppxPackage -Path $app
