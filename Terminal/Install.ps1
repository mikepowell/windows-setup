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

. (Join-Path $PSScriptRoot "../Utilities/Fonts.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Utilities.ps1")

# Nothing selected? Show help screen.
if (!$PowerShellProfile.IsPresent -and !$Fonts.IsPresent -and !$WindowsTerminalSettings.IsPresent `
        -and !$OhMyPosh.IsPresent -and !$All.IsPresent) {
    Get-Help .\Install.ps1
    Exit;
}

# Powershell
# Profiles are stored in OneDrive, with symlinks from the actual profile location.
function AddSymlink([string]$path, [string]$filename) {
    $profileFile = Join-Path ([System.IO.Path]::GetDirectoryName($profile)) $filename
    if (!(Test-Path $profileFile) -or $Force.IsPresent) {
        Write-Host "Adding Powershell profile symlink for '$filename'..."
        $sourceFile = Join-Path $env:OneDriveConsumer 'Documents' 'Powershell Profiles' $filename
        New-Item -ItemType SymbolicLink -Path $profileFile -Target $sourceFile -Force | Out-Null
    }
    else {
        Write-Host "PowerShell profile '$filename' already exists."
        Write-Host 'Use the -Force switch to overwrite.';
    }
}

if ($All.IsPresent -or $PowerShellProfile.IsPresent) {
    # Check whether onedrive consumer is installed & signed in yet
    if (!(Test-Path $env:OneDriveConsumer)) {
        Write-Host 'OneDrive (consumer version) must be installed and signed in before Powershell profiles can be created.'
    }
    else {
        AddSymlink -filename 'Microsoft.PowerShell_profile.ps1'
        AddSymlink -filename 'Microsoft.VSCode_profile.ps1'
        AddSymlink -filename 'PSReadlineProfile.ps1'
        AddSymlink -filename '.oh-my-posh.json'
    }
}

# Windows Terminal
if ($All.IsPresent -or $WindowsTerminalSettings.IsPresent) {
    Assert-Administrator -FailMessage 'Installing Windows Terminal settings requires administrator privileges.'

    $TerminalLocalState = Join-Path $Env:LOCALAPPDATA 'Packages' 'Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe' 'LocalState'
    if (!(Test-Path -Path $TerminalLocalState -PathType Container)) {
        throw 'Windows Terminal Preview is not installed.'
    }

    # Create symlink to Windows Terminal settings
    $TerminalSettingsTarget = Join-Path $PSScriptRoot '../Config/windows_terminal.json'
    $TerminalSettingsPath = Join-Path $TerminalLocalState 'settings.json'
    if (Test-Path $TerminalSettingsPath) {
        Remove-Item -Path $TerminalSettingsPath
    }

    New-Item -Path $TerminalSettingsPath -ItemType SymbolicLink -Value $TerminalSettingsTarget | Out-Null

    # Set user environment variables that contains the path to custom terminal images
    $ImagesPath = Join-Path $PSScriptRoot 'Images'
    [Environment]::SetEnvironmentVariable('WINDOWSTERMINAL_IMAGES', "$ImagesPath", 'User')
}

# Fonts
if ($All.IsPresent -or $Fonts.IsPresent) {
    # Install RobotoMono font
    Write-Host "Installing Cascadia Code and  RobotoMono nerd fonts..."
    $FontPath = Join-Path $PWD "Fonts"
    Install-Font -FontPath "$FontPath\CaskaydiaCoveMono.ttf"
    Install-Font -FontPath "$FontPath\RobotoMono.ttf"
}

