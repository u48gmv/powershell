clear-host
<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

$webUrl = "http://spvm/sites/rund"
$listName = "Rundschreiben"

Write-Host "Start deleting items" -ForegroundColor Yellow
$list = (get-spweb $webUrl).lists[$listName]
$li = $list.Items
$lic = $li.count
Write-Host "List $listName has $lic items"

foreach ($item in $li) {
    $itemId = $item.id
    $itemTitle = $item.Title
    $list.getitembyid($itemId).Delete()    
    Write-Host "Item $itemTitle deleted" -ForegroundColor Magenta    
}
Write-Host "Done deleting items" -ForegroundColor Green
