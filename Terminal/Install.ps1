[CmdletBinding(DefaultParameterSetName='Granular')]
Param(
    [Parameter(ParameterSetName='All')]
    [switch]$All,

    [Parameter(ParameterSetName='Granular')]
    [switch]$PowerShellProfile,

    [Parameter(ParameterSetName='Granular')]
    [switch]$Fonts,

    [Parameter(ParameterSetName='Granular')]
    [switch]$WindowsTerminalSettings,

    [Parameter(ParameterSetName='Granular')]
    [switch]$OhMyPosh,

    [switch]$Force
)

. (Join-Path $PSScriptRoot "../Utilities/Fonts.ps1")
. (Join-Path $PSScriptRoot "../Utilities/Utilities.ps1")

# Nothing selected? Show help screen.
if (!$PowerShellProfile.IsPresent -and !$Fonts.IsPresent -and !$WindowsTerminalSettings.IsPresent `
    -and !$OhMyPosh.IsPresent -and !$All.IsPresent)
{
    Get-Help .\Install.ps1
    Exit;
}

# Powershell

if ($All.IsPresent -or $PowerShellProfile.IsPresent) {
    if (!(Test-Path $PROFILE) -or $Force.IsPresent) {
        # Update PowerShell profile
        Write-Host "Adding PowerShell profile...";
        $MachinePath = (Get-Item (Join-Path $PSScriptRoot "../../")).FullName
        $PowerShellProfileTemplatePath = Join-Path $PSScriptRoot "PowerShell/Profile.template";
        $PowerShellProfilePath = (Join-Path $PSScriptRoot "PowerShell/Roaming.ps1");
        $PowerShellPromptPath = (Join-Path $PSScriptRoot "PowerShell/Prompt.ps1");
        $PowerShellLocalProfilePath = Join-Path (Get-Item $PROFILE).Directory.FullName "LocalProfile.ps1"
        Copy-Item -Path $PowerShellProfileTemplatePath -Destination $PROFILE;
        # Replace placeholder values
        (Get-Content -path $PROFILE -Raw) -Replace '<<MACHINE>>', $MachinePath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<PROFILE>>', $PowerShellProfilePath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<PROMPT>>', $PowerShellPromptPath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<LOCALPROFILE>>', $PowerShellLocalProfilePath | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<SOURCELOCATION>>', "$($Global:SourceLocation)" | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<AZURELOCATION>>', "$($Global:AzureDevOpsSourceLocation)" | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<BITBUCKETLOCATION>>', "$($Global:BitBucketSourceLocation)" | Set-Content -Path $PROFILE
        (Get-Content -path $PROFILE -Raw) -Replace '<<GITLABLOCATION>>', "$($Global:GitLabSourceLocation)" | Set-Content -Path $PROFILE
    } else {
        Write-Host "PowerShell profile already exist.";
        Write-Host "Use the -Force switch to overwrite.";
    }
}

# Windows Terminal

if ($All.IsPresent -or $WindowsTerminalSettings.IsPresent) {
    Assert-Administrator -FailMessage 'Installing Windows Terminal settings requires administrator privileges.';

    $TerminalLocalState = Join-Path $Env:LOCALAPPDATA 'Packages' 'Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe' 'LocalState'
    if (!(Test-Path -Path $TerminalLocalState -PathType Container)) {
        throw 'Windows Terminal Preview is not installed.'
    }

    # Create symlink to Windows Terminal settings
    $TerminalSettingsTarget = Join-Path $PSScriptRoot '../Config/windows_terminal.json'
    $TerminalSettingsPath = Join-Path $TerminalLocalState 'settings.json'
    if(Test-Path $TerminalSettingsPath) {
        Remove-Item -Path $TerminalSettingsPath
    }

    New-Item -Path $TerminalSettingsPath -ItemType SymbolicLink -Value $TerminalSettingsTarget | Out-Null

    # Set user environment variables that contains the path to custom terminal images
    $ImagesPath = Join-Path $PSScriptRoot 'Images'
    [Environment]::SetEnvironmentVariable('WINDOWSTERMINAL_IMAGES', "$ImagesPath", 'User')
}

# Fonts

if($All.IsPresent -or $Fonts.IsPresent) {
    # Install RobotoMono font
    Write-Host "Installing RobotoMono nerd font..."
    $FontPath = Join-Path $PWD "Fonts/CaskaydiaCoveMono.ttf";
    Install-Font -FontPath $FontPath;
}


# Oh-my-posh

if($All.IsPresent -or $OhMyPosh.IsPresent) {
    $OhMyPoshPath = "$env:LOCALAPPDATA\Oh-My-Posh"
    $OhMyPoshExe = Join-Path $OhMyPoshPath "oh-my-posh.exe"

    # Download?
    if(!(Test-Path $OhMyPoshExe) -or $Force.IsPresent) {
        Write-Host "Downloading Oh-My-Posh..."
        New-Item -Path $env:LOCALAPPDATA\Oh-My-Posh -ItemType Directory -ErrorAction Ignore | Out-Null

        if(Test-Path $OhMyPoshExe) {
            Remove-Item $OhMyPoshExe | Out-Null
        }

        Invoke-Webrequest "https://github.com/JanDeDobbeleer/oh-my-posh3/releases/latest/download/posh-windows-amd64.exe" -OutFile $OhMyPoshExe

    } else {
        Write-Debug "Oh-My-Posh already installed"
    }

    # Add to PATH?
    $CurrentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User");
    if(!($CurrentPath -like "*$OhMyPoshPath*")) {
        Write-Host "Setting PATH variable..."
        [Environment]::SetEnvironmentVariable("PATH", "$CurrentPath;$OhMyPoshPath", "User")
    } else {
        Write-Debug "PATH variable already set"
    }
}
