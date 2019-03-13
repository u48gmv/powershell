<# Get the Webapplication by name#>
$w = Get-SPWebApplication "HostNameTest" 
<# Create a new Host Names Site Collection #>
New-SPSite http://HostA.SharePoint.com -OwnerAlias "Domain\usename" -HostHeaderWebApplication $w -Name "Some name for the sitecollection" -Template "BLANKINTERNETCONTAINER#0"