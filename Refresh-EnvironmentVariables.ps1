<#PSScriptInfo

.VERSION 2.0.0

.GUID 9ff8b18d-cc46-449e-81f1-bbdacc3f41b4

.AUTHOR asherto

.COMPANYNAME asheroto

.TAGS PowerShell Windows refresh reload path env environment variable variables update current

.PROJECTURI https://github.com/asheroto/Refresh-EnvironmentVariables

.RELEASENOTES
[Version 0.0.1] - Initial Release.
[Version 1.0.0] - Total rework of script, implementing Chocolatey's Update-SessionEnvironment function into one single script.
[Version 1.0.1] - Rename to Refresh-EnvironmentVariables to avoid naming conflicts with Chocolatey's RefreshEnv.cmd.
[Version 1.0.2] - Fix bug with CheckForUpdate.
[Version 1.1.0] - Fix PATH ordering, prevent overwriting critical environment variables, and remove stale environment variables from session
[Version 2.0.0] - Total redesign, now supports the ability to remove deleted entries from path.

#>

<#
.SYNOPSIS
    Refreshes the environment variables in the current PowerShell session.
.DESCRIPTION
    Refreshes the environment variables in the current PowerShell session.
.EXAMPLE
	Refresh-EnvironmentVariables
.PARAMETER CheckForUpdate
    Checks if there is an update available for the script.
.PARAMETER Version
    Displays the version of the script.
.PARAMETER Help
    Displays the full help information for the script.
.NOTES
	Version      : 2.0.0
	Created by   : asheroto
.LINK
	Project Site: https://github.com/asheroto/Refresh-EnvironmentVariables
#>
[CmdletBinding()]
param (
    [switch]$Version,
    [switch]$Help,
    [switch]$CheckForUpdate,
    [switch]$RemoveStale
)

# Derived from the original work by Chocolatey Software, used in accordance with license
# Copyright © 2017 - 2021 Chocolatey Software, Inc.

# Based on concepts from Chocolatey's Update-SessionEnvironment
# Rewritten and extended for standalone use

# Original license, included per the terms of the Apache 2.0 license:
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.

# Version
$CurrentVersion = '2.0.0'
$RepoOwner = 'asheroto'
$RepoName = 'Refresh-EnvironmentVariables'
$PowerShellGalleryName = 'Refresh-EnvironmentVariables'

# Versions
$ProgressPreference = 'SilentlyContinue'
$ConfirmPreference = 'None'

if ($Version.IsPresent) {
    $CurrentVersion
    exit 0
}

if ($Help) {
    Get-Help -Name $MyInvocation.MyCommand.Source -Full
    exit 0
}

function Get-GitHubRelease {
    [CmdletBinding()]
    param (
        [string]$Owner,
        [string]$Repo
    )
    try {
        $url = "https://api.github.com/repos/$Owner/$Repo/releases/latest"
        $response = Invoke-RestMethod -Uri $url -ErrorAction Stop

        $latestVersion = $response.tag_name
        $publishedAt = $response.published_at

        $UtcDateTime = [DateTime]::Parse($publishedAt, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::RoundtripKind)
        $PublishedLocalDateTime = $UtcDateTime.ToLocalTime()

        [PSCustomObject]@{
            LatestVersion     = $latestVersion
            PublishedDateTime = $PublishedLocalDateTime
        }
    } catch {
        Write-Error "Unable to check for updates.`nError: $_"
        exit 1
    }
}

function CheckForUpdate {
    param (
        [string]$RepoOwner,
        [string]$RepoName,
        [version]$CurrentVersion,
        [string]$PowerShellGalleryName
    )

    $Data = Get-GitHubRelease -Owner $RepoOwner -Repo $RepoName

    if ($Data.LatestVersion -gt $CurrentVersion) {
        Write-Output "`nA new version of $RepoName is available.`n"
        Write-Output "Current version: $CurrentVersion."
        Write-Output "Latest version: $($Data.LatestVersion)."
        Write-Output "Published at: $($Data.PublishedDateTime).`n"
        Write-Output "https://github.com/$RepoOwner/$RepoName/releases`n"
        if ($PowerShellGalleryName) {
            Write-Output "Install-Script $PowerShellGalleryName -Force`n"
        }
    } else {
        Write-Output "`n$RepoName is up to date.`n"
    }
    exit 0
}

if ($CheckForUpdate) {
    CheckForUpdate -RepoOwner $RepoOwner -RepoName $RepoName -CurrentVersion $CurrentVersion -PowerShellGalleryName $PowerShellGalleryName
}

function Get-EnvironmentVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string] $Name,
        [Parameter(Mandatory = $true)][System.EnvironmentVariableTarget] $Scope,
        [switch] $PreserveVariables
    )

    if ($Scope -eq [System.EnvironmentVariableTarget]::Process) {
        return [Environment]::GetEnvironmentVariable($Name, $Scope)
    }

    $keyPath = if ($Scope -eq 'User') { 'Environment' } else { 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment' }
    $registry = if ($Scope -eq 'User') { [Microsoft.Win32.Registry]::CurrentUser } else { [Microsoft.Win32.Registry]::LocalMachine }

    try {
        $key = $registry.OpenSubKey($keyPath)
        if ($null -ne $key) {
            $value = $key.GetValue($Name, '')
            $key.Close()
            if ($value) { return $value }
        }
    } catch {}

    return [Environment]::GetEnvironmentVariable($Name, $Scope)
}

function Get-EnvironmentVariableNames {
    param([System.EnvironmentVariableTarget] $Scope)

    switch ($Scope) {
        'User' { Get-Item 'HKCU:\Environment' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Property }
        'Machine' { Get-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' | Select-Object -ExpandProperty Property }
        'Process' { Get-ChildItem Env:\ | Select-Object -ExpandProperty Key }
    }
}

function Update-SessionEnvironment {
    <#
.SYNOPSIS
Updates the environment variables of the current powershell session...
#>
    param (
        [switch]$RemoveStale
    )

    $userName = $env:USERNAME
    $architecture = $env:PROCESSOR_ARCHITECTURE
    $psModulePath = $env:PSModulePath

    $ScopeList = 'Process', 'Machine'
    if ('SYSTEM', "${env:COMPUTERNAME}`$" -notcontains $userName) {
        $ScopeList += 'User'
    }

    $skip = @(
        'PATH', 'PSModulePath', 'USERNAME', 'PROCESSOR_ARCHITECTURE',
        # Windows login-derived variables (not stored in registry)
        'USERPROFILE', 'APPDATA', 'LOCALAPPDATA', 'HOMEDRIVE', 'HOMEPATH',
        'PUBLIC', 'ALLUSERSPROFILE', 'USERDOMAIN', 'USERDOMAIN_ROAMINGPROFILE',
        'LOGONSERVER', 'SESSIONNAME', 'COMPUTERNAME'
    )

    foreach ($Scope in $ScopeList) {
        Get-EnvironmentVariableNames -Scope $Scope | ForEach-Object {
            if ($skip -contains $_) { return }

            $value = Get-EnvironmentVariable -Scope $Scope -Name $_
            if ($null -ne $value -and $value -ne '') {
                Set-Item "Env:$_" -Value $value -ErrorAction SilentlyContinue
            }
        }
    }

    # PATH fix
    $machinePath = Get-EnvironmentVariable -Name 'PATH' -Scope Machine
    $userPath = Get-EnvironmentVariable -Name 'PATH' -Scope User
    $env:PATH = @($machinePath, $userPath) -join ';'

    # Remove stale variables
    if ($RemoveStale) {
        $validNames = @()
        $validNames += Get-EnvironmentVariableNames -Scope Machine
        $validNames += Get-EnvironmentVariableNames -Scope User
        $validNames = $validNames | Select-Object -Unique

        Get-ChildItem Env: | ForEach-Object {
            if ($skip -contains $_.Name) { return }
            if ($validNames -notcontains $_.Name) {
                Remove-Item "Env:$($_.Name)" -ErrorAction SilentlyContinue
            }
        }
    }

    $env:PSModulePath = $psModulePath
    if ($userName) { $env:USERNAME = $userName }
    if ($architecture) { $env:PROCESSOR_ARCHITECTURE = $architecture }
}

Write-Output "Refreshing environment variables..."
Update-SessionEnvironment -RemoveStale:$RemoveStale
Write-Output "Finished"