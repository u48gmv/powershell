### Removes a manged path ###
Clear-Host

<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 

### Init params ###

$managedPaths = @("seiten");
foreach ($managedPath in $managedPaths) 
{
	Remove-SPManagedPath $managedPath -HostHeader -Confirm:$false -ErrorAction Ignore;
    Write-Host "Following managed path was removed -> $managedPath" -ForegroundColor Green -BackgroundColor Black;
}

### Remove SharePoint Snap In ###
Remove-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue;



