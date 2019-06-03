### Set continuous crawl interval ###

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";

$ssa = Get-SPEnterpriseSearchServiceApplication;
$ssa.GetProperty("ContinuousCrawlInterval");
#$ssa.SetProperty("ContinuousCrawlInterval",5);