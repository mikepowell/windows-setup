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
  exit
}

$docs = [Environment]::GetFolderPath("MyDocuments")
$wpsProfileDir = "$docs\WindowsPowerShell"
$pwshProfileDir = "$docs\PowerShell"

<#
Untested code, check before running

All this is to work around issues related to onedrive KFM and PowerShellGet installing modules to the user's Documents folder.
Modules installed on other machines are available due to OneDrive sync, but are not updatable or uninstallable via powershellget.
#>
New-Item -ItemType Directory ~\.powershell\Modules  # will also create the ~\.powershell folder
New-Item -ItemType Directory ~\.powershell\Scripts
New-Item -ItemType Junction "$pwshProfileDir\Modules" -Value ~\.powershell\Modules
New-Item -ItemType Junction "$pwshProfileDir\Scripts" -Value ~\.powershell\Scripts

New-Item -ItemType Directory ~\.windowspowershell\Modules  # will also create the ~\.windowspowershell folder
New-Item -ItemType Directory ~\.windowspowershell\Scripts
New-Item -ItemType Junction "$wpsProfileDir\Modules" -Value ~\.windowspowershell\Modules
New-Item -ItemType Junction "$wpsProfileDir\Scripts" -Value ~\.windowspowershell\Scripts

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

# Install modules used in my profile
Install-Module -Name oh-my-posh -Force
Install-Module -Name posh-git -Force
Install-Module -Name Terminal-Icons -Force
