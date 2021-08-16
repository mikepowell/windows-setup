# Load some utilities
. (Join-Path $PSScriptRoot "..\Utilities.ps1")

# This script must be run as admin
Assert-Administrator

# It also must be run from PS 5.1, not core.
if ($PSVersionTable.PSEdition -eq 'Core') {
  throw 'This script does not support PowerShell Core, it must be run from a PowerShell 5.1 console.'
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

# Windows features that are kind of like apps
choco install TelnetClient -source WindowsFeatures

# Uninstall bloatware
Get-AppxPackage *Autodesk* | Remove-AppxPackage
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
