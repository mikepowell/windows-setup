<#
  Edge profiles
  Coding fonts
  https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip
  Git
  Sign in to OneDrive
  Symlinks (c:\git, c:\mp)
  Create git directories
    - \git\iihs
    - \git\iihs-it
    - \git\github
    - \git\github\mikepowell
  Turn off checkboxes in explorer
  Turn on Win10 Developer Mode
  Install Store apps?
    - To-do
    - Terminal
#>

Set-ExecutionPolicy RemoteSigned
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1'));
Get-Boxstarter -Force

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

# Enable Windows subsystem for Linux
choco install --cache="$ChocoCachePath" --yes Microsoft-Windows-Subsystem-Linux -source windowsfeatures

# Install apps
choco upgrade --cache="$ChocoCachePath" --yes discord
choco upgrade --cache="$ChocoCachePath" --yes powertoys
choco upgrade --cache="$ChocoCachePath" --yes git
choco upgrade --cache="$ChocoCachePath" --yes 7zip
choco upgrade --cache="$ChocoCachePath" --yes screentogif
choco upgrade --cache="$ChocoCachePath" --yes chocolateygui
choco upgrade --cache="$ChocoCachePath" --yes powershell-core
choco upgrade --cache="$ChocoCachePath" --yes ripgrep
choco upgrade --cache="$ChocoCachePath" --yes gsudo
choco upgrade --cache="$ChocoCachePath" --yes nugetpackageexplorer
choco upgrade --cache="$ChocoCachePath" --yes docker-for-windows
choco upgrade --cache="$ChocoCachePath" --yes sysinternals
choco upgrade --cache="$ChocoCachePath" --yes nodejs
choco upgrade --cache="$ChocoCachePath" --yes curl
choco upgrade --cache="$ChocoCachePath" --yes vscode
choco upgrade --cache="$ChocoCachePath" --yes dotpeek --pre

# Install posh-git
PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
