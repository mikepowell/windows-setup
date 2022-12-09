# Install applications
$apps = @(
  @{ name = 'PowerShell'; id = '9MZ1SNWT0N5D' },
  @{ name = 'Sysinternals Suite'; id = '9P7KNL5RWT25' },
  @{ name = 'Mirosoft PowerToys'; id = 'XP89DCGQ3K6VLD' },
  @{
    name = 'VS Code'
    id = ''
    override = '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
  },
  @{ name = 'Discord'; id = '' },
  @{ name = 'Inkscape'; id = '' },
  @{ name = 'paint.net'; id = '' },
  @{ name = 'Git.Git'; id = '' },
  @{ name = '7-zip'; id = '' },
  @{ name = 'Node.js'; id = '' },
  @{ name = 'Beyond Compare 4'; id = '' },
  @{ name = 'Remote Desktop Manager'; id = '' },
  @{ name = 'Microsoft .NET SDK'; id = '' },
  @{ name = 'LogFusion'; id = '' },
  @{ name = 'Telerik.Fiddler.Classic'; id = '' },
  @{ name = 'FileZilla Client'; id = '' }
)

# This all needs to be rewritten - don't run as-is yet
foreach ($app in $apps) {
  $installed = winget list --id "$($app.id)"
  if ($installed) {
    Write-Output "App '$($app.name)' is already installed."
  }
  else {
    # Prefer the msstore package if available.
    if (winget search --id "$($app.id)" --source "msstore") {
      Write-Output "Installing app '$($app.name)' from msstore."
      if ($app.override) {
        winget install --id "$($app.id)" --source msstore --exact --accept-package-agreements --accept-source-agreements
      }
      else {
        winget install --id "$($app.id)" --source msstore --exact --accept-package-agreements --accept-source-agreements --override "`'$($app.override)`'"
      }
      # winget install Microsoft.VisualStudioCode --override '/SILENT '
    }
    else {
      Write-Output "Installing app '$app' from winget."
      winget install --query "$app" --accept-package-agreements --accept-source-agreements
    }
  }
}

# Uninstall bloatware
Get-AppxPackage *Autodesk* | Remove-AppxPackage
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage
Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage
