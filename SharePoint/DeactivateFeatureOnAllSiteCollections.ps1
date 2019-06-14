### Deactivate feature for all sites in a web application ###
clear-host

### Add SharePoint Snap In ###
<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

$featuresToDisable = @("MDSFeature","CrossSiteCollectionPublishing");

<# Get all Web Applications, and iterate through them #>
$webAppUrls = Get-SPWebApplication;

foreach($webApp in $webAppUrls){
    <# Get all site collectinos of the current web application #>
    write-host "Disabling features in Web Application " $webApp.Name -ForegroundColor Yellow;
    $spsites = get-spsite -limit all -WebApplication $webApp.Url;
    foreach($spsite in $spsites){
        <# Iterate through all the provided features and deactivate them #>
        foreach($featureToDisable in $featuresToDisable){
            Disable-SPFeature -Identity $featureToDisable -Url $spsite.Url -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
            Write-Host "Disabled $featureToDisable on: " $spsite.Url -ForegroundColor Green;
        }
    }
}



 


