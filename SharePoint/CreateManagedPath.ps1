<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

<# Get webappliction #>
$wa = Get-SPWebApplication "HostNameTest"

<# Show managed paths of the webapplication #>
Get-SPManagedPath -WebApplication $wa

<# Create a new managed path #>
New-SPManagedPath "example_path" -HostHeader -Explicit -WebApplication $wa

<# Create a site using this managed path#>
New-SPSite http://HostA.SharePoint.com/example_path/test01 -OwnerAlias "SHAREPOINT\kirkevans" -HostHeaderWebApplication $wa -Name "HostA Content Type Hub" -Template "sts#0"