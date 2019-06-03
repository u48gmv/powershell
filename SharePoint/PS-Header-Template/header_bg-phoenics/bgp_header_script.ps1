<#
Header file 

    .SYNOPSIS
        A summary of how the script works and how to use it.
    
    .DESCRIPTION
        A long description of how the script works and how to use it.
  
    .NOTES
        Information about the environment, things to need to be consider and other information. 
 
    .COMPONENT
        Information about PowerShell Modules to be required.
 
    .LINK
        Useful Link to ressources or others.
 
    .Parameter ParameterName
        Description for a parameter in param definition section. 
        Each parameter requires a separate description. 
        The name in the description and the parameter section must match.

    .EXAMPLE
        And second example - more text documentation
	    Appears in -detailed and -full

    .INPUTTYPE
       Documentary text, eg:
       Input type  Universal.SolarSystem.Universe.SOL.Earth.CommonSense
       Appears in -full

    .RETURNVALUE
       Documentary Text, eg:
       Output type  Universal.Wisdom
       Appears in -full

Note: The variables $app* are declared in appMetadata.ps1
#>
Function Print-AppHeader {
$header = @"
#########################################################################
____   _____            _____  _                      _          
|  _ \ / ____|          |  __ \| |                    (_)         
| |_) | |  __   ______  | |__) | |__   ___   ___ _ __  _  ___ ___ 
|  _ <| | |_ | |______| |  ___/| '_ \ / _ \ / _ \ '_ \| |/ __/ __|
| |_) | |__| |          | |    | | | | (_) |  __/ | | | | (__\__ \
|____/ \_____|          |_|    |_| |_|\___/ \___|_| |_|_|\___|___/

Script name: $sName
Script version: $sVersion
Script author: $sAuthor
Author email: $aEmail

#########################################################################

"@
    Write-Host $header -ForegroundColor Blue
}
