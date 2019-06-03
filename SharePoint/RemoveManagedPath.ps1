### Removes a manged path ###
Clear-Host

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";

### Init params ###

$managedPaths = @("seiten");
foreach ($managedPath in $managedPaths) 
{
	Remove-SPManagedPath $managedPath -HostHeader -Confirm:$false -ErrorAction Ignore;
    Write-Host "Following managed path was removed -> $managedPath" -ForegroundColor Green -BackgroundColor Black;
}

### Remove SharePoint Snap In ###
Remove-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue;



