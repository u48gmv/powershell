Clear-Host

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";

$searchServiceApplicationName = "Search Service Application"
$csn = "Local SharePoint sites"

$SSA = Get-SPEnterpriseSearchServiceApplication -Identity $searchServiceApplicationName

$sa = Get-SPEnterpriseSearchCrawlContentSource -Identity $csn -SearchApplication $SSA

if ($sa.CrawlStatus -ne "Idle")
{
    Write-Host "Stopping currently running crawl for content source $($sa.Name)"
    $sa.StopCrawl()
    
    do { Start-Sleep -Seconds 1 }
    while ($sa.CrawlStatus -ne "Idle")
}
