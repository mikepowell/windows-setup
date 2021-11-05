# Mike's PC setup

This repository contains my personal configuration for a Windows
PC. Feel free to fork this repository or use it as an
inspiration for your own configurations.

> **Warning!!**
> Running the scripts here without knowing what they do
> will most likely make you sad and/or change your
> computer settings to something that you don't want.

## Store app installation

Some apps still have to be (or should be) installed from the Microsoft Store. The ones I use
often are listed here for reference:

* [Windows Terminal Preview](https://www.microsoft.com/store/productId/9N8G5RFZ9XK3)
* [Microsoft To Do](https://www.microsoft.com/store/productId/9NBLGGH5R558)
* [Python](https://www.microsoft.com/store/productId/9P7QFQMJRFP7)
* [Sysinternals Suite](https://www.microsoft.com/store/productId/9P7KNL5RWT25)
* [paint.net](https://www.microsoft.com/store/productId/9NBHCS1LX4R0)
* [Inkscape](https://www.microsoft.com/store/productId/9PD9BHGLFC7H)

## Windows configuration

### Sign in to OneDrive

This configuration expects Powershell profiles to be stored in OneDrive Consumer,
so make sure you're signed in to the OneDrive sync client with a personal Microsoft account.

As for the Powershell modules folder (in the user's "My Documents" library),
I've never been able to make it work well across multiple machines with OneDrive,
so I recommend *not* having the sync client automatically redirect the My Documents
folder to OneDrive. The downside is that you'll need to be vigilant and not just
store other documents in the default "My Documents" if you want them backed up to OneDrive.

### Set Powershell execution policy

Launch Powershell as administrator and run the following command.

```powershell
> Set-ExecutionPolicy RemoteSigned
```

### Install Chocolatey

To download these scripts at all, you'll first need Git installed, and since Chocolatey is
required for the scripts you might as well install it manually now. Run the following in
the same admin Powershell console.

```powershell
> [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
> iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### A note about your elevated PowerShell terminal

If you're using a separate admin account for setting up this PC that will not end up being your
normal day-to-day login you'll run into some issues with some of these scripts because PowerShell
will run in the context of the admin user and not your normal user. So any user-specific actions
taken by the script will affect the wrong user.

One workaround for this is to install [gsudo](https://github.com/gerardog/gsudo), and use the
`sudo` command to start an elevated session inside the PowerShell session started as your regular
user. The gsudo session runs in your normal user's profile/environment, so the scripts will work
properly to set things up for that user.

You can use Chocolatey at this point to install gsudo:

```powershell
> choco install gsudo
```

### Install Git for Windows

```powershell
> choco install git
```

### Clone this repository

```powershell
> git clone https://github.com/mikepowell/windows-setup.git
```

### Run setup scripts

#### 1_Apps.ps1

This script installs fonts and apps, mostly via Chocolatey. Must be run as admin.

#### 2_Git.ps1

Sets various Git settings, and creates my preferred folder structure for local repos.

#### 3_Powershell.ps1

Sets up PowerShell to use my profile from my personal OneDrive storage. This script must
be run as admin, but *also must be run from your non-admin user's environment*. See note
above for more info on this. Also installs PowerShell modules required by my profile.

#### 4_WindowsTerminal.ps1

Sets up Windows Terminal Preview to use settings from personal OneDrive storage, in the
folder `/Documents/.ConsoleProfiles`. Must run as admin since it creates a symlink.

Note that you'll see an error about background images if you run this from the Windows
Terminal Preview app. Just ignore it and restart the app and your background images
should be fine.

## Acknowledgement

Inspiration for this repo is from Patrik Svensson's
**[machine](https://github.com/patriksvensson/machine)**
repository. Thank you!
