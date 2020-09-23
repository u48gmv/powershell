<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }


#Init params
$url = "";

#Get the Site Collection
$Site = Get-SPSite $url;
 
#Delete all from 1st Stage Recycle bin
$Site.AllWebs | Foreach-object { $_.RecycleBin.MoveAllToSecondStage() };
 
#Empty 2nd Stage Recycle bin
$Site.RecycleBin.DeleteAll();