# Utility functions

function Set-RegistryDword([string]$Path, [string]$Name, [int]$Value) {
    If (!(Test-Path $Path)) {
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Type DWord -Value $Value
}

# Disable UAC (temporarily)
Disable-UAC

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

# Enable Windows subsystem for Linux
if($env:UserName -ne "WDAGUtilityAccount") { # Can't install this on Sandbox
    choco install --cache="$ChocoCachePath" --yes Microsoft-Windows-Subsystem-Linux -source windowsfeatures
    choco install --cache="$ChocoCachePath" --yes VirtualMachinePlatform -source windowsfeatures
    choco install --cache="$ChocoCachePath" --yes Microsoft-Hyper-V-All -source windowsFeatures
}

# Install Windows Sandbox
if($env:UserName -ne "WDAGUtilityAccount") { # Can't install this on Sandbox
    Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" -All -Online
}

# Windows settings

Disable-BingSearch
Disable-GameBarTips

Set-RegistryDword -Path 'HKLM:SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1
Set-WindowsExplorerOptions -EnableShowFileExtensions
Set-BoxstarterTaskbarOptions -Size Large -Dock Bottom -Combine Always -Lock -NoAutoHide

# Power settings

powercfg /change monitor-timeout-ac 90 # Turn off monitor after 90 minutes
powercfg /change standby-timeout-ac 0 # Don't ever sleep

# Uninstall bloatware

Get-AppxPackage *Autodesk* | Remove-AppxPackage
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage
Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage

# Privacy

# Privacy: Let apps use my advertising ID: Disable
Set-RegistryDword -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0

# WiFi Sense: HotSpot Sharing: Disable
Set-RegistryDword -Path 'HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting' -Name 'value' -Value 0

# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-RegistryDword -Path 'HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots' -Name 'value' -Value 0

# User interface

# Windows 10 developer mode
Set-RegistryDword -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' -Name 'AllowDevelopmentWithoutDevLicense' -Value 1

# Change Explorer launch location to Quick Access
Set-RegistryDword -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 2

# Start Menu: Disable Bing Search Results
Set-RegistryDword -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0

# Turn off People in Taskbar
Set-RegistryDword -Path 'HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0

# Enable the lock screen if it's been disabled.
Set-RegistryDword -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreen' -Value 0

# Restore Temporary Settings
Enable-UAC
Enable-MicrosoftUpdate
