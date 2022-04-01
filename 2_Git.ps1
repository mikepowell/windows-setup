# Load some utilities
. (Join-Path $PSScriptRoot "..\Utilities.ps1")

# This script must be run as admin
Assert-Administrator

# Use Beyond Compare for diffs and merges
git config --global diff.tool bc
git config --global difftool.bc.path "c:/Program Files/Beyond Compare 4/bcomp.exe"

git config --global merge.tool bc
git config --global mergetool.bc.path "c:/Program Files/Beyond Compare 4/bcomp.exe"

git config --global core.editor "code --wait"

function New-DirIfNotExist([string]$Path) {
  if (!(Test-Path $path)) {
    New-Item -ItemType Directory -Path $Path
  }
}

# Create initial folder structure. I use 'iihs' and 'iihs-it' for work stuff, and 'github'
# for any repos I clone from GitHub (including my own personal ones).
New-DirIfNotExist -Path "$env:USERPROFILE\git"
New-DirIfNotExist -Path "$env:USERPROFILE\git\iihs"
New-DirIfNotExist -Path "$env:USERPROFILE\git\iihs-it"
New-DirIfNotExist -Path "$env:USERPROFILE\git\github"
New-DirIfNotExist -Path "$env:USERPROFILE\git\github\mikepowell"

New-Item -ItemType SymbolicLink -Path "$env:HOMEDRIVE\mp" -Target "$env:USERPROFILE" -Force | Out-Null
New-Item -ItemType SymbolicLink -Path "$env:HOMEDRIVE\git" -Target "$env:USERPROFILE\git" -Force | Out-Null
