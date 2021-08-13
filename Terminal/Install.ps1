[CmdletBinding(DefaultParameterSetName = 'Granular')]
Param(
    [Parameter(ParameterSetName = 'All')]
    [switch]$All,

    [Parameter(ParameterSetName = 'Granular')]
    [switch]$PowerShellProfile,

    [Parameter(ParameterSetName = 'Granular')]
    [switch]$Fonts,

    [Parameter(ParameterSetName = 'Granular')]
    [switch]$WindowsTerminalSettings,

    [Parameter(ParameterSetName = 'Granular')]
    [switch]$OhMyPosh,

    [switch]$Force
)

. (Join-Path $PSScriptRoot "..\Utilities.ps1")

# Nothing selected? Show help screen.
if (!$PowerShellProfile.IsPresent -and !$Fonts.IsPresent -and !$WindowsTerminalSettings.IsPresent `
        -and !$OhMyPosh.IsPresent -and !$All.IsPresent) {
    Get-Help .\Install.ps1
    Exit;
}



