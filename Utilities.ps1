# This script is referenced by the setup scripts. No need to run it
# manually.

Function Assert-Administrator {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if(!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        throw 'This script must be run as an administrator.'
    }
}

Function Assert-CommandExists([string]$CommandName) {
    $Old = $ErrorActionPreference;
    try {
        $ErrorActionPreference = "stop";
        if (Get-Command $CommandName) {
            Return $true;
        }
        Return $false;
    } catch {
        Return $false;
    } finally {
        $ErrorActionPreference = $Old;
    }
}

function Set-RegistryDword([string]$Path, [string]$Name, [int]$Value) {
    If (!Test-Path $Path) {
        New-Item -Path $Path -ItemType Directory | Out-Null
    }
    Set-ItemProperty -Path $Path -Name $Name -Type DWord -Value $Value
}
