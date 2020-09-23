Clear-Host
# SharePoint Server Search         56171eb5-5eac-42fe-ae39-42cab98c6e32
# Search Host Controller Service   9c7daf1c-df44-4e9a-a43b-08854c7a0728


<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 


#Unprovision Search Host Controller Service
$srvc = Get-SPServiceInstance "9c7daf1c-df44-4e9a-a43b-08854c7a0728"
$srvc.Unprovision()

#Unprovision SharePoint Server Search
$srvc = Get-SPServiceInstance "56171eb5-5eac-42fe-ae39-42cab98c6e32"
$srvc.Unprovision()


#Provision Search Host Controller Service
$srvc = Get-SPServiceInstance "9c7daf1c-df44-4e9a-a43b-08854c7a0728"
$srvc.Provision()

#Provision SharePoint Server Search
$srvc = Get-SPServiceInstance "56171eb5-5eac-42fe-ae39-42cab98c6e32"
$srvc.Provision()

Get-SPServiceInstance | Where-Object{$_.TypeName -eq "SharePoint Server Search" -or $_.TypeName -eq "Search Host Controller Service"}
