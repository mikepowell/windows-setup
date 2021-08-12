function Set-RegistryDword([string]$Path, [string]$Name, [int]$Value) {
    If (!(Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Type DWord -Value $Value
}

# Windows settings

# Enable long paths
Set-RegistryDword -Path 'HKLM:SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
# Misc Explorer options
Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowHiddenFilesFoldersDrives -EnableShowFullPathInTitleBar
# Windows 10 developer mode
Set-RegistryDword -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name 'AllowDevelopmentWithoutDevLicense' -Value 1
# Turn off People in Taskbar
Set-RegistryDword -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0

# Power settings
powercfg /change monitor-timeout-ac 90 # Turn off monitor after 90 minutes
powercfg /change standby-timeout-ac 0 # Don't ever sleep

# Windows features
choco install TelnetClient -source WindowsFeatures
