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

"Password length is $($password.length)" | Add-Content "c:\temp\dummypasswords.log"