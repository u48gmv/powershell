### Add Snap Ins if not already loaded ###
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
foreach ($snapInToAdd in $snapInsToAdd) 
{
    if ( (Get-PSSnapin -Name $snapInToAdd -ErrorAction SilentlyContinue) -eq $null )
    {
        Add-PSSnapin $snapInToAdd;
        Write-Host "$snapInToAdd loaded" -ForegroundColor Green;

    }else{
        
        Write-Host "$snapInToAdd already loaded" -ForegroundColor Magenta;

    }
}

### Delete a site collection (easy way) ###
Remove-SPSite -Confirm:$false -GradualDelete  -Identity "https://test.sp.ms.bgnet.de/sites/bgpdebug22"

### Delete a site collection brute force way ###
$siteUrls = @($URL);
foreach ($siteUrl in $siteUrls) 
{
	Try{
        $site = get-spsite $siteUrl -ErrorAction Stop;
    }
    Catch{
        $ErrorMessage = $_.Exception.Message;
        $FailedItem = $_.Exception.ItemName;        
        Write-Warning -Message $ErrorMessage;     
    }
    
    if($site){
	    $siteId = $site.Id;
	    $siteDatabase = $site.ContentDatabase;
	    $siteDatabase.ForceDeleteSite($siteId, $false, $false);
        Write-Host "Following site was deleted -> " -ForegroundColor Green -BackgroundColor Black -NoNewline;
        write-host $siteUrl -ForegroundColor Yellow -BackgroundColor Black;       
    }

}

### Get all Site Collections within a given Web Application ###
$webApplication = "https://test.sp.ms.bgnet.de"

## Select ID and URL and export to a XML file
get-spwebapplication $webApplication | Get-SPSite -Limit All | Select ID, URL | Export-Clixml -Path ./test.xml

## Select URL and export to a CSV file
get-spwebapplication $webApplication | Get-SPSite -Limit All | Select URL | Export-Csv -Path ./sc.txt


### Add an additional site collection admin ###
$user = "ms\u48gmv"
$siteUrl = "https://test.sp.ms.bgnet.de/sites/ttr"

New-SPUser -UserAlias $user -Web $siteUrl -SiteCollectionAdmin

### List all available Site-Templates###
$siteTemplates = get-spwebtemplate;
$siteTemplates;

### Create Host Named SiteCollection SPSite ###
$Template="STS#1";
$WebApp = "https://demo-farm.aw-ibs-sp.local/ "
$URL = "https://XXXXXX.prod.sp.ppro.bgnet.de";
$Owner = "aw-ibs-sp\u48gmv_sp";
$Name ="BG Phoenics Portal";
$Description ="Das Portal der BG Phoenics";
$ContentDB ="DEMO_Content_Portal"
$Language = 1033

$site = New-SPSite -URL $URL -HostHeaderWebApplication $WebApp  -OwnerAlias $Owner -Language $Language -Template $Template -Name $Name -Description $Description  -ContentDatabase $ContentDB  
Write-Host "Host named site collection created. Visit is on -> " -ForegroundColor Green -NoNewline;
Write-Host $URL -ForegroundColor Yellow;

### Set default groups ###
$url = "http://bg-phoenics.prod.sp.ppro.bgnet.de/team/bgrci";
Try{
    $site=get-spsite $url -ErrorAction Stop;
}
Catch{
    $ErrorMessage = $_.Exception.Message;
    $FailedItem = $_.Exception.ItemName;        
    Write-Warning -Message $ErrorMessage;         
}
if($site){
    $web=$site.RootWeb;
    $web.AssociatedOwnerGroup = $null;
    $web.AssociatedMemberGroup = $null;
    $web.AssociatedVisitorGroup = $null;
    $web.CreateDefaultAssociatedGroups($site.Site.Owner.UserLogin, $site.Site.SecondaryContact.UserLogin, $site.Title);
}


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

### Change the continuous crawl interval ###
$intervalInMinutes = 5;
$ssa = Get-SPEnterpriseSearchServiceApplication;
$ssa.SetProperty("ContinuousCrawlInterval",$intervalInMinutes);


### Delete a folder in the directory where the current script is running ###
$scriptToExecute = "D:\TEST\testScript.ps1";
$relativeFolderPath = "folder\subFolder";
$CommandDirectory = [System.IO.Path]::GetDirectoryName($scriptToExecute);
$folderToDelete = Join-Path -Path $CommandDirectory -ChildPath $relativeFolderPath;
Remove-Item -Path $folderToDelete -Force -Recurse;
Write-Host "--------------------------------------------------" -ForegroundColor Green;
Write-Host "Following folder was deleted: $folderToDelete" -ForegroundColor Yellow;
Write-Host "--------------------------------------------------" -ForegroundColor Green;

### Enable/Disable feature ###
$URL = "https://site-url";
Get-SPFeature; #  Show all available features
Enable-SPFeature -Identity "MDSFeature" -Url $URL; # Enable minimum download strategy feature
Disable-SPFeature -Identity "MDSFeature" -Url $URL -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature

### Export a Site Collection ###
$siteUrl = "https://url-der-site-collection/";
$backUpFile = "Absoulter Pfad der Datei";
Export-SPWeb $SiteUrl -Path $backUpFile -Force;

### Import a Site Collection ###
$siteUrl = "https://url-der-site-collection/";
$backUpFile = "Absoulter Pfad der Datei";
Import-SPWeb -Identity $siteUrl -Path $backUpFile -Force -Verbose;


### Add a managed path for Host Named Site Collections ###
$siteManagedPath = "team";
New-SPManagedPath $siteManagedPath -HostHeader;

### Get a managed path for Host Named Site Collections ###
$siteManagedPath = "team";
Get-SPManagedPath -identity $siteManagedPath -HostHeader

### Delete a managed path for Host Named Site Collections ###
$siteManagedPath = "team";
Remove-SPManagedPath $siteManagePath -HostHeader

 