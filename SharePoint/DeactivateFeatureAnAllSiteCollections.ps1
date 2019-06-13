### Deactivate feature for all sites in a web application ###
clear-host

### Add SharePoint Snap In ###
<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

$webAppUrl = "http://sp2019vm";
$featureToDisable = "MDSFeature";


$spsites = get-spsite -limit all -WebApplication $webAppUrl;

foreach($spsite in $spsites){
    Disable-SPFeature -Identity $featureToDisable -Url $spsite.Url -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
    Write-Host "Disabled $featureToDisable on: " $spsite.Url -ForegroundColor Green;
}