# Load some utilities
. (Join-Path $PSScriptRoot "..\Utilities.ps1")

# This script must be run as admin
Assert-Administrator

# Install applications
$apps = @(
  'PowerShell'
  'Sysinternals Suite'
  'PowerToys'
  'Discord'
  'Inkscape'
  'paint.net'
  'Git.Git'
  '7-zip'
  'Node.js'
  'Beyond Compare 4'
  'Remote Desktop Manager'
  'Microsoft .NET SDK'
  'LogFusion'
  'Telerik.Fiddler.Classic'
  'FileZilla Client'
)

foreach ($app in $apps) {
  $installed = winget list --query "$app"
  if ($installed -match $app) {
    Write-Output "App '$app' is already installed."
  }
  else {
    # Prefer the msstore package if available.
    if ((winget search --query "$app" --source "msstore") -match $app) {
      Write-Output "Installing app '$app' from msstore."
      winget install --query "$app" --source msstore --accept-package-agreements --accept-source-agreements
    }
    else {
      Write-Output "Installing app '$app' from winget."
      winget install --query "$app" --accept-package-agreements --accept-source-agreements
    }
  }
}

# Uninstall bloatware
Get-AppxPackage *Autodesk* | Remove-AppxPackage
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
