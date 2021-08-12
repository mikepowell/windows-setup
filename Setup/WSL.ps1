# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

# Enable Windows subsystem for Linux
choco install --cache="$ChocoCachePath" --yes Microsoft-Windows-Subsystem-Linux -source windowsfeatures
choco install --cache="$ChocoCachePath" --yes VirtualMachinePlatform -source windowsfeatures

# Remind me to install the WSL2 Linux kernel update package
$updateInstalled = Get-ChildItem 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\' `
  | ForEach-Object { $_.GetValue('DisplayName') } `
  | Where-Object { $_ -eq 'Windows Subsystem for Linux Update' }
if (!$updateInstalled) {
  Write-Host "You need to install the WSL kernel update!"
  Start-Process 'https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package'
}

# Make sure WSL 2 is the default architecture
wsl --set-default-version 2

# Install Ubuntu
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Downloads/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Downloads/Ubuntu.appx
RefreshEnv

# Update Ubuntu
Ubuntu1804 install --root
Ubuntu1804 run apt-get update -y
Ubuntu1804 run apt-get upgrade -y
