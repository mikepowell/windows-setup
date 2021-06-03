Function Assert-Administrator([string]$FailMessage) {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if(!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
        Throw $FailMessage
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
