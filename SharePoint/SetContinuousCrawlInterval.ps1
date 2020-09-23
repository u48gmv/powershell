### Set continuous crawl interval ###

<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 

$ssa = Get-SPEnterpriseSearchServiceApplication;
$ssa.GetProperty("ContinuousCrawlInterval");
#$ssa.SetProperty("ContinuousCrawlInterval",5);