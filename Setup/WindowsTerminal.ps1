[CmdletBinding()]
param(
  [switch]$Force
)

# Assert-Administrator

$terminalLocalState = Join-Path $Env:LOCALAPPDATA 'Packages' 'Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe' 'LocalState'
if (!(Test-Path -Path $TerminalLocalState -PathType Container)) {
  throw 'Windows Terminal Preview is not installed.'
}

$consoleProfiles = Join-Path $env:OneDriveConsumer '\Documents\.ConsoleProfiles'

$terminalSettings = Join-Path $consoleProfiles 'windows_terminal.json'
if (!(Test-Path $terminalSettings)) {
  throw "Settings file '$terminalSettings' was not found. No symlink created."
}

$linkTarget = Join-Path $terminalLocalState 'settings.json'
if (Test-Path $linkTarget) {
  if ((Get-Item $linkTarget).ItemType -ne 'SymbolicLink') {
    if (!$Force.IsPresent) {
      throw "Settings file '$linkTarget' already exists as a file. Use the -Force parameter to overwrite."
    }
  }
}

New-Item -ItemType SymbolicLink -Path $linkTarget -Target $terminalSettings -Force | Out-Null

# Set user environment variables that contains the path to custom terminal images
$ImagesPath = Join-Path $consoleProfiles 'Images'
[Environment]::SetEnvironmentVariable('WINDOWSTERMINAL_IMAGES', "$ImagesPath", 'User')
