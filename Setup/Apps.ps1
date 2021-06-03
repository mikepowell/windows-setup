# Disable UAC (temporarily)
Disable-UAC

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

# Install applications

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

# Restore Temporary Settings

Enable-UAC
Enable-MicrosoftUpdate
