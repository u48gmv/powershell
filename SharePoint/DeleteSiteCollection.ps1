<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

<#
Delete site collection through PowerShell
To delete site collection in SharePoint 2013 using PowerShell, use Remove-SPSite cmdlet.
#>
Remove-SPSite -Identity "<Site-Collection-URL>"
# E.g.
Remove-SPSite -Identity "http://sharepoint.crescent.com/sites/operations" 

<#
Remove-SPSite cmdlet with -GradualDelete switch:
The -GradualDelete parameter instructs to delete the site collection gradually, instead of consuming all system resources to delete the site collection instantly in a single stretch. This reduces the load on the system when deleting large site collections.
#>
Remove-SPSite -Identity "Site-collection-URL" -GradualDelete

<#
Force delete SharePoint site collection with PowerShell
If you face any difficulty in deleting SharePoint site collection either from Central Admin or with PowerShell, you can force delete site collection from content database as:
#>
#Get the site collection to delete
$Site = Get-SPSite http://site-collection-url
#Get the content database of the site collection
$SiteContentDB = $site.ContentDatabase 
#Force delete site collection
$SiteContentDB.ForceDeleteSite($Site.Id, $false, $false)

<#
Bulk delete site collections with PowerShell in SharePoint 2013 
How about bulk deleting multiple site collections? Say, You want to delete all site collections under the given managed path: /Sites?
#>
Get-SPSite "http://sharepoint.crescent.com/sites*" -Limit ALL | Remove-SPSite -Confirm:$false

<#
PowerShell to delete all site collections under a web application:
If you don't want to send your SharePoint sites to recycle bin and would like to remove them permanently, use: 
#>
#Web Application URL
$WebAppURL="http://SharePoint.crescent.com"
#Get Each site collection and delete
Get-SPWebApplication $WebAppURL | Get-SPSite -Limit ALL | Remove-SPSite -Confirm:$false


