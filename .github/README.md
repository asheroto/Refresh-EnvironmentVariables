![Refresh-EnvironmentVariables](https://github.com/asheroto/Refresh-EnvironmentVariables/assets/49938263/baedbab3-f1c3-4965-9b5e-a9674781093a)

[![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/Refresh-EnvironmentVariables?label=PowerShell%20Gallery%20downloads)](https://www.powershellgallery.com/packages/Refresh-EnvironmentVariables)
[![GitHub Release Date - Published_At](https://img.shields.io/github/release-date/asheroto/Refresh-EnvironmentVariables)](https://github.com/asheroto/Refresh-EnvironmentVariables/releases)
[![GitHub Downloads - All Releases](https://img.shields.io/github/downloads/asheroto/Refresh-EnvironmentVariables/total)](https://github.com/asheroto/Refresh-EnvironmentVariables/releases)
[![GitHub Sponsor](https://img.shields.io/github/sponsors/asheroto?label=Sponsor&logo=GitHub)](https://github.com/sponsors/asheroto)
<a href="https://ko-fi.com/asheroto"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Ko-Fi Button" height="20px"></a>

# Refresh-EnvironmentVariables

Refreshes/reloads the environment variables in the current PowerShell session without needing to close and reopen PowerShell.

## How It Works

The script reads environment variables directly from the Windows registry (`HKCU\Environment` for user scope, `HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment` for machine scope) and applies them to the current session.

**PATH** is rebuilt by combining the machine PATH followed by the user PATH, which matches the standard Windows precedence order.

**Stale variable removal** — by default, stale variables are left in place. Use `-RemoveStale` to remove any session variable that no longer exists in the registry (e.g. cleaned up by an uninstaller). Known Windows login-derived variables (such as `USERPROFILE`, `APPDATA`, `LOCALAPPDATA`, etc.) are always excluded from this check since they are set by Windows at logon and are not stored in the registry.

## Setup

### Method 1 - PowerShell Gallery

Open PowerShell as Administrator and run:

```powershell
Install-Script Refresh-EnvironmentVariables -Force
```

Follow the prompts to complete the installation (tap `A` to accept all prompts).

**Note:** `-Force` is optional but recommended, as it will force the script to update if it is outdated.

The script is published on [PowerShell Gallery](https://www.powershellgallery.com/packages/Refresh-EnvironmentVariables) under `Refresh-EnvironmentVariables`.

#### Tip - How to trust PSGallery

If you want to trust PSGallery so you aren't prompted each time:

```powershell
Install-PackageProvider -Name "NuGet" -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
```

### Method 2 - Download Locally and Run

- Download the latest [Refresh-EnvironmentVariables.ps1](https://github.com/asheroto/Refresh-EnvironmentVariables/releases/latest/download/Refresh-EnvironmentVariables.ps1) from [Releases](https://github.com/asheroto/Refresh-EnvironmentVariables/releases)
- Run the script with `.\Refresh-EnvironmentVariables.ps1`

## Usage

```powershell
Refresh-EnvironmentVariables
```

To also remove session variables that no longer exist in the registry:

```powershell
Refresh-EnvironmentVariables -RemoveStale
```

## Alias

To add a shorter alias, add the following to your PowerShell profile:

```powershell
New-Alias -Name RefreshEnv -Value Refresh-EnvironmentVariables
```

Aliases take precedence over functions, cmdlets, and exe/bat/cmd files, so you can type `RefreshEnv` instead of `Refresh-EnvironmentVariables`. This is not set by default to avoid naming conflicts with Chocolatey's `refreshenv` cmd script.

## Parameters

| Parameter         | Description                                                                                           |
| ----------------- | ----------------------------------------------------------------------------------------------------- |
| `-RemoveStale`    | Removes session variables that no longer exist in the registry. Off by default.                       |
| `-CheckForUpdate` | Checks if there is an update available for the script.                                                |
| `-Version`        | Displays the version of the script.                                                                   |
| `-Help`           | Displays the full help information for the script.                                                    |

## Contributing

Fork the repo, make your changes, and submit a pull request.