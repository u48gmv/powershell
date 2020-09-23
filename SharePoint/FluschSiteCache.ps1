### Flush output cache of sites ###

<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 

### Init stuff ##
$userName = "sp48spfarmdev02";
$webAppUrl = "https://dev02.sp.ppro.bgnet.de";
$stURL = "https://bgp.dev02.sp.ppro.bgnet.de";

Add-SPShellAdmin -UserName $userName;
$webApplication = Get-SPWebApplication $webAppUrl;


$out = [System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SharePoint”) 
$out = [System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SharePoint.Publishing”)


### Flush output cache ###
$siteUrls = @($stURL);
foreach ($siteUrl in $siteUrls) {
    $site = get-spsite $siteUrl;
    if ([Microsoft.SharePoint.Publishing.PublishingWeb]::IsPublishingWeb($site.RootWeb)) {
        Write-Host ("Flushing output cache on " + $site.Url + "... ") -ForegroundColor Magenta
        $cacheSettings = new-object Microsoft.SharePoint.Publishing.SiteCacheSettingsWriter($site); 
        $cacheSettings.SetFarmCacheFlushFlag()
        $cacheSettings.Update();        
    } else { 
        Write-Host ("Skipping " + $site.Url + " as publishing feature is not enabled.") -ForegroundColor Yellow
    }
}





