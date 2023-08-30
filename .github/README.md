![RefreshEnv](PATH)

[![GitHub Release Date - Published_At](https://img.shields.io/github/release-date/asheroto/RefreshEnv)](https://github.com/asheroto/RefreshEnv/releases)
[![GitHub Downloads - All Releases](https://img.shields.io/github/downloads/asheroto/RefreshEnv/total)](https://github.com/asheroto/RefreshEnv/releases)
[![GitHub Sponsor](https://img.shields.io/github/sponsors/asheroto?label=Sponsor&logo=GitHub)](https://github.com/sponsors/asheroto)
<a href="https://ko-fi.com/asheroto"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Ko-Fi Button" height="20px"></a>

# Refresh Environment Variables

## Features
-  Refreshes the environment variables in the current PowerShell session
-  No need to close and reopen PowerShell

## Setup

### Method 1 - PowerShell Gallery

**Note:** please use the latest version using Install-Script or the PS1 file from Releases, the version on GitHub itself may be under development and not work properly.

Open PowerShell as Administrator and type

```powershell
Install-Script RefreshEnv -Force
```

Follow the prompts to complete the installation (you can tap `A` to accept all prompts or `Y` to select them individually.

**Note:** `-Force` is optional but recommended, as it will force the script to update if it is outdated.

The script is published on [PowerShell Gallery](https://www.powershellgallery.com/packages/RefreshEnv) under `RefreshEnv`.

### Tip - How to trust PSGallery

If you want to trust PSGallery so you aren't prompted each time you run this command, or if you're scripting this and want to ensure the script isn't interrupted the first time it runs...

```powershell
Install-PackageProvider -Name "NuGet" -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
```

### Method 2 - Download Locally and Run

-   Download the latest [RefreshEnv.ps1](https://github.com/asheroto/RefreshEnv/releases/latest/download/RefreshEnv.ps1) from [Releases](https://github.com/asheroto/RefreshEnv/releases)
-   Run the script with `.\RefreshEnv.ps1`

## Usage

In PowerShell, type

```powershell
RefreshEnv
```

## Parameters

No parameters are required to run the script, but there are some optional parameters to use if needed.

| Parameter         | Required | Description                                                                                 |
| ----------------- | -------- | ------------------------------------------------------------------------------------------- |
| `-CheckForUpdate` | No       | Checks if there is an update available for the script.                                      |
| `-Version`        | No       | Displays the version of the script.                                                         |
| `-Help`           | No       | Displays the full help information for the script.                                          |

## Contributing

If you're like to help develop this project: fork the repo, make your changes, and submit a pull request. 😊