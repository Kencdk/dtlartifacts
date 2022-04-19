<#
Installs an existing certificate to the LocalMachine store.
Creates a self signed certificate and imports it into you Personal and Root stores. 
I used this when setting up a new development site on dev machine.
#>
[CmdletBinding()]
Param(
    [ValidateNotNullOrEmpty()]
    [string] $password
)

if(-not (Test-Path "c:\\temp\\"))
{
    New-Item -Path "c:\" -Name "temp" -ItemType "directory" | out-null
}

"Password length is $($password.length)" | Out-File -FilePath "c:\\temp\\dummypasswords.log"