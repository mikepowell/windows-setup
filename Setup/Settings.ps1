# Load some utilities
. (Join-Path $PSScriptRoot "..\Utilities.ps1")

# This script must be run as admin
Assert-Administrator

function Set-RegistryDword([string]$Path, [string]$Name, [int]$Value) {
    If (!(Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Type DWord -Value $Value
}

# Power settings
powercfg /change monitor-timeout-ac 30 # Turn off monitor after 90 minutes
powercfg /change standby-timeout-ac 60 # Sleep after 60 minutes

# Enable long paths
Set-RegistryDword -Path 'HKLM:SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
# Disable checkboxes in Explorer
Set-RegistryDword -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -Value 0
# Windows 10 developer mode
Set-RegistryDword -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name 'AllowDevelopmentWithoutDevLicense' -Value 1
# Turn off People in Taskbar
Set-RegistryDword -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0

# Other misc Explorer options. This BoxStarter command also restarts explorer.exe so by doing it last we'll
# pick up the registry settings above.
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowHiddenFilesFoldersDrives -EnableShowFullPathInTitleBar

