<#
.SYNOPSIS
    Writes the current datetime to a file.

.DESCRIPTION
.EXAMPLE
    
.NOTES
    Author: Ken Christensen (github.com/kencdk/)
    Last Edit: 2020-07-27
    Version 1.0 - initial script.
#>  

$filename = "$($env:SystemDrive)\\temp\\installdate.txt"
get-date | out-file -filepath $filename -append