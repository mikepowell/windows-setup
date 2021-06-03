# Mike's PC setup

This repository contains my personal configuration for a Windows
PC. Feel free to fork this repository or use it as an
inspiration for your own configurations.

> **Warning!!**
> Running the scripts here without knowing what they do
> will most likely make you sad and/or change your
> computer settings to something that you don't want.

## Windows configuration

It's recommended to run this in two steps.
PowerShell must be launched as administrator.

### 1. Set execution policy

Launch PowerShell as administrator and run the following command.

```powershell
> Set-ExecutionPolicy RemoteSigned
```

### 2. Install prereqs

There are some things that require a restart to work correctly,
so start by installing this.

```powershell
> ./Install.ps1 -Prereqs
```

After prereqs are installed, restart the computer.
If the script asks you if you want to restart the computer,
do that, and run the script again after reboot.

### 3. Install applications and/or Ubuntu

```powershell
> ./Install.ps1 -Apps -Ubuntu
```

## Acknowledgement

Inspiration for this repo and most of the initial content is
from Patrik Svensson's **[machine](https://github.com/patriksvensson/machine)**
repository. Thank you!
