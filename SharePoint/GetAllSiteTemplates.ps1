### Delete and create Host Named SiteCollection SPSite ###
Clear-Host

<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 

Get-spwebtemplate