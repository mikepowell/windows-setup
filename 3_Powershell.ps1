[CmdletBinding()]
param(
  [switch]$Force
)

# Profiles are stored in OneDrive, with symlinks from the actual profile location.
function AddSymlink([string]$path) {
  if (!(Test-Path $path) -or $Force.IsPresent) {
    Write-Host "Adding Powershell profile symlink for '$path'..."

    $filename = [System.IO.Path]::GetFileName($path)
    $sourceFile = "$($env:OneDriveConsumer)\Documents\.ConsoleProfiles\$filename"
    if (Test-Path $sourceFile) {
      New-Item -ItemType SymbolicLink -Path $path -Target $sourceFile -Force | Out-Null
    }
    else {
      Write-Host "Profile source '$sourceFile' was not found. No symlink created."
    }
  }
  else {
    Write-Host "PowerShell profile '$path' already exists."
    Write-Host 'Use the -Force switch to overwrite.';
  }
}

# Check whether onedrive consumer is installed & signed in yet
if (!(Test-Path $env:OneDriveConsumer)) {
  Write-Host 'OneDrive (consumer version) must be installed and signed in before Powershell profiles can be created.'
}
else {
  $docs = [Environment]::GetFolderPath("MyDocuments")
  $wpsProfileDir = "$docs\WindowsPowerShell"
  $pwshProfileDir = "$docs\PowerShell"

  # Add links for PS 5.1
  AddSymlink -path "$wpsProfileDir\Microsoft.PowerShell_profile.ps1"
  AddSymlink -path "$wpsProfileDir\Microsoft.VSCode_profile.ps1"
  AddSymlink -path "$wpsProfileDir\PSReadlineProfile.ps1"
  AddSymlink -path "$wpsProfileDir\.oh-my-posh.json"

  # Add links for Core
  AddSymlink -path "$pwshProfileDir\Microsoft.PowerShell_profile.ps1"
  AddSymlink -path "$pwshProfileDir\Microsoft.VSCode_profile.ps1"
  AddSymlink -path "$pwshProfileDir\PSReadlineProfile.ps1"
  AddSymlink -path "$pwshProfileDir\.oh-my-posh.json"
}

# Install modules used in my profile
Install-Module -Name oh-my-posh -Force
Install-Module -Name posh-git -Force
Install-Module -Name Terminal-Icons -Force
