# Load some utilities
. (Join-Path $PSScriptRoot "..\Utilities.ps1")

# This script must be run as admin
Assert-Administrator

# It also must be run from PS 5.1, not core.
if ($PSVersionTable.PSEdition -eq 'Core') {
  powershell.exe -NoProfile -File $MyInvocation.MyCommand.Path
  return
}

# Install applications
choco upgrade --yes powershell-core
choco upgrade --yes discord
choco upgrade --yes powertoys
choco upgrade --yes git
choco upgrade --yes 7zip
choco upgrade --yes ripgrep
choco upgrade --yes gsudo
choco upgrade --yes nugetpackageexplorer
choco upgrade --yes docker-for-windows
choco upgrade --yes sysinternals
choco upgrade --yes nodejs
choco upgrade --yes curl
choco upgrade --yes vscode
choco upgrade --yes dotpeek --pre
choco upgrade --yes beyondcompare
choco upgrade --yes rdm
choco upgrade --yes dotnet-sdk
choco upgrade --yes logfusion
choco upgrade --yes fiddler

# Windows features that are kind of like apps
Write-Host
if (!(Get-WindowsOptionalFeature -FeatureName TelnetClient -Online)) {
  Write-Host 'Installing telnet client...'
  choco install TelnetClient -source WindowsFeatures
}
else {
  Write-Host 'Telnet client already installed, skipping.'
}

# Uninstall bloatware
Get-AppxPackage *Autodesk* | Remove-AppxPackage
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
