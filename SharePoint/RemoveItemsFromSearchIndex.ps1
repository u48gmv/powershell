Clear-Host
<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }
$Url = "https://portal.prod.sp.ppro.bgnet.de/teamsite/testing_gmv_intver_001"

$ssas = Get-SPEnterpriseSearchServiceApplication

foreach ($ssa in $ssas) {
    $cl = New-Object Microsoft.Office.Server.Search.Administration.CrawlLog $ssa
    $logEntries = $cl.GetCrawledUrls($false, 100, $Url, $true, -1, -1, -1, [System.DateTime]::MinValue, [System.DateTime]::MaxValue)

    foreach ($logEntry in $logEntries.Rows) {
        Write-Host "Trying to remove " -NoNewline
        Write-Host $logEntry.FullUrl -ForegroundColor Green
        $catch = $cl.RemoveDocumentFromSearchResults($logEntry.FullUrl)
        if ($catch) {
            Write-Host "Deleted" -ForegroundColor Yellow
        }
        else {
            Write-Host "Could not delete the item" -ForegroundColor Red
        }
    }
}