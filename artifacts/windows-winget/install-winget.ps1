<#
.SYNOPSIS
    Installs the Windows Package Manager Client (winget)

.DESCRIPTION
    Downloads the latest release of Windows Package Manager Client from GitHub and installs it.

.EXAMPLE
    
.NOTES
    Author: Ken Christensen (github.com/kencdk/)
    Last Edit: 2020-06-02
    Version 1.0 - initial installation script.
#>  

###################################################################################################
#
# PowerShell configurations
#

# NOTE: Because the $ErrorActionPreference is "Stop", this script will stop on first failure.
#       This is necessary to ensure we capture errors inside the try-catch-finally block.
$ErrorActionPreference = 'Stop'

# Suppress progress bar output.
$ProgressPreference = 'SilentlyContinue'

# Ensure we force use of TLS 1.2 for all downloads.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

###################################################################################################
#
# Handle all errors in this script.
#

trap
{
    # NOTE: This trap will handle all errors. There should be no need to use a catch below in this
    #       script, unless you want to ignore a specific error.
    $message = $Error[0].Exception.Message
    if ($message)
    {
        Write-Host -Object "`nERROR: $message" -ForegroundColor Red
    }

    Write-Host "`nThe artifact failed to apply.`n"

    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}

###################################################################################################
#
# Functions used in this script.
#

function FindLatestGithubRelease(){
    $repo = "microsoft/winget-cli"
    $file = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle"
    $releases = "https://api.github.com/repos/$repo/releases"

    Write-Host Determining latest release
    $releasesBlob = Invoke-WebRequest $releases
    $releasesObj = ConvertFrom-Json -InputObject $releasesBlob
    return $releasesObj
}

function DownloadRelease($releasesObj, $tempFolder) {
    $downloadurl = $releasesObj.assets[0].browser_download_url
    Write-Host "Downloading asset: $downloadurl into $tempFolder"
    
    $tempFile = join-path $tempFolder $downloadurl.split("/")[-1]
    Invoke-WebRequest $downloadurl -OutFile $tempFile

    return $tempFile
}

###################################################################################################
#
# Main execution block.
#

try
{
    pushd $PSScriptRoot

    Write-Host "Determining latest release from GitHub"
    $latestRelease = FindLatestGithubRelease
    Write-Host "Determined $($latestRelease.tag_name) to be the latest release"
    
    $tempFolder = New-TemporaryFile | %{ rm $_; mkdir $_ }
    $tempFile = Downloadrelease($latestRelease)

    write-host "Installing .appxbundle package"
    Add-AppxPackage -Path $tempFile

    # Removing temp files
    Remove-Item $tempFolder -Recurse -Force

    Write-Host "`nThe artifact was applied successfully.`n"
}
finally
{
    popd
}