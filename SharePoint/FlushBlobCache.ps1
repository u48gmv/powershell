###Flush BLOB cache ###

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";

### Init stuff ##
$userName = "sp48spfarmdev02";
$webAppUrl = "https://dev02.sp.ppro.bgnet.de";

Add-SPShellAdmin -UserName $userName;
$webApplication = Get-SPWebApplication $webAppUrl;
[Microsoft.SharePoint.Publishing.PublishingCache]::FlushBlobCache($webApp);
Write-Host "Flushed the BLOB cache for:" $webApp;


$out = [System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SharePoint”) 
$out = [System.Reflection.Assembly]::LoadWithPartialName(“Microsoft.SharePoint.Publishing”)

foreach ($site in $webApplication.Sites) {
    if ([Microsoft.SharePoint.Publishing.PublishingWeb]::IsPublishingWeb($site.RootWeb)) {
        Write-Host ("Flushing output cache on " + $site.Url + "... ") -ForegroundColor Magenta
        $cacheSettings = new-object Microsoft.SharePoint.Publishing.SiteCacheSettingsWriter($site); 
        $cacheSettings.SetFarmCacheFlushFlag()
        $cacheSettings.Update();        
    } else { 
        Write-Host ("Skipping " + $site.Url + " as publishing feature is not enabled.") -ForegroundColor Yellow
    }
}





