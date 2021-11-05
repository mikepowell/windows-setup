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

### 1. Sign in to OneDrive

This configuration expects Powershell profiles to be stored in OneDrive Consumer,
so make sure you're signed in to the OneDrive sync client with a personal Microsoft account.

As for the Powershell modules folder (in the user's "My Documents" library),
I've never been able to make it work well across multiple machines with OneDrive,
so I recommend *not* having the sync client automatically redirect the My Documents
folder to OneDrive. The downside is that you'll need to be vigilant and not just
store other documents in the default "My Documents" if you want them backed up to OneDrive.

### 2. Set Powershell execution policy

Launch Powershell as administrator and run the following command.

```powershell
> Set-ExecutionPolicy RemoteSigned
```

### 3. Install Chocolatey

To download these scripts at all, you'll first need Git installed, and since Chocolatey is
required for the scripts you might as well install it manually now. Run the following in
the same admin Powershell console.

```powershell
> [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
> iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### 4. Install Git for Windows

```powershell
> choco install git
```

### 5. Clone this repository

```powershell
> git clone https://github.com/mikepowell/windows-setup.git
```

### 6. Run other scripts

More info to come later after the scripts are more finished.

## Acknowledgement

Inspiration for this repo and most of the initial content is
from Patrik Svensson's **[machine](https://github.com/patriksvensson/machine)**
repository. Thank you!
