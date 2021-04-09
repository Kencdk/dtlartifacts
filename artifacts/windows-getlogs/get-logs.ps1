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
        Write-Host -Object "`nERROR: $message at $($Error[0].Exception.StackTrace)" -ForegroundColor Red
    }

    Write-Host "`nThe artifact failed to apply.`n"

    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}

$gitclones = get-childitem -filter gitclone.err -path C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.10\Downloads\ -r
write-host "Found $($gitclones.length) file(s)"
write-host $($gitclones | get-content)