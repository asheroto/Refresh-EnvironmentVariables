![Refresh-EnvironmentVariables](https://github.com/asheroto/Refresh-EnvironmentVariables/assets/49938263/c8a47342-1ccc-4188-91df-9f6073fef3eb)

[![GitHub Release Date - Published_At](https://img.shields.io/github/release-date/asheroto/Refresh-EnvironmentVariables)](https://github.com/asheroto/Refresh-EnvironmentVariables/releases)
[![GitHub Downloads - All Releases](https://img.shields.io/github/downloads/asheroto/Refresh-EnvironmentVariables/total)](https://github.com/asheroto/Refresh-EnvironmentVariables/releases)
[![GitHub Sponsor](https://img.shields.io/github/sponsors/asheroto?label=Sponsor&logo=GitHub)](https://github.com/sponsors/asheroto)
<a href="https://ko-fi.com/asheroto"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Ko-Fi Button" height="20px"></a>

# Refresh-EnvironmentVariables

Refreshes/reloads the environment variables in the current PowerShell session.

No need to close and reopen PowerShell.

## Setup

### Method 1 - PowerShell Gallery

**Note:** please use the latest version using Install-Script or the PS1 file from Releases, the version on GitHub itself may be under development and not work properly.

Open PowerShell as Administrator and type

```powershell
Install-Script Refresh-EnvironmentVariables -Force
```

Follow the prompts to complete the installation (you can tap `A` to accept all prompts or `Y` to select them individually.

**Note:** `-Force` is optional but recommended, as it will force the script to update if it is outdated.

The script is published on [PowerShell Gallery](https://www.powershellgallery.com/packages/Refresh-EnvironmentVariables) under `Refresh-EnvironmentVariables`.

### Tip - How to trust PSGallery

If you want to trust PSGallery so you aren't prompted each time you run this command, or if you're scripting this and want to ensure the script isn't interrupted the first time it runs...

```powershell
Install-PackageProvider -Name "NuGet" -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
```

### Method 2 - Download Locally and Run

-   Download the latest [Refresh-EnvironmentVariables.ps1](https://github.com/asheroto/Refresh-EnvironmentVariables/releases/latest/download/Refresh-EnvironmentVariables.ps1) from [Releases](https://github.com/asheroto/Refresh-EnvironmentVariables/releases)
-   Run the script with `.\Refresh-EnvironmentVariables.ps1`

## Usage

In PowerShell, type

```powershell
Refresh-EnvironmentVariables
```

If you want to add an alias to the command, you can add the following to your PowerShell profile:

```powershell
New-Alias -Name RefreshEnv -Value Refresh-EnvironmentVariables
```

The reason we did not make this the default is that it can conflict with Chocolatey's `refreshenv` cmd script.

## Parameters

No parameters are required to run the script, but there are some optional parameters to use if needed.

| Parameter         | Required | Description                                                                                 |
| ----------------- | -------- | ------------------------------------------------------------------------------------------- |
| `-CheckForUpdate` | No       | Checks if there is an update available for the script.                                      |
| `-Version`        | No       | Displays the version of the script.                                                         |
| `-Help`           | No       | Displays the full help information for the script.                                          |

## Contributing

If you're like to help develop this project: fork the repo, make your changes, and submit a pull request. 😊