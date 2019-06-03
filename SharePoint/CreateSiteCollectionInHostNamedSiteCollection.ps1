### Create a website on a Host Named Sitecollection using managed paths ###
clear-host

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";


### Init ###
### Init parameters ###
#$Template="STS#0"; ### Team site
#$Template="BLANKINTERNET#0"; ### Publishing site
#$Template="DEV#0"; ### Developer site
$Template="STS#0"; ### Standard team site
$Language = 1031; ### German
$WebApp = "http://test.sp.ppro.bgnet.de";
$rootSite = "https://shared.test.sp.ppro.bgnet.de"; ## This Host named site collection needs to exist. NOTE: No leading or trailing slashes
$sitePath = "mrkt"; ### The new site collection beneath the managed path "team. NOTE: No leading or trailing slashes"
$siteManagedPath = "app" ### The managed path to use. NOTE: No leading or trailing slashes ##
$Owner = "ppro\sp48spsetuptest";
$Name ="Marktplatz";
$Description ="Kleinanzeigen für alle Mitarbeiter";
$ContentDB ="QA_Content_Portal_001"
$siteCollectionAdmins = @("ms\u48pru","ms\u48wst","ms\u48gmv","ms\u480tbs","ms\u48hhh","ms\u48mll","ms\u48gsc","ms\u48rqa","ms\u48lpd","ppro\sp48backupadm");

### Start logic for creating site collection  ###

### Check if the managed path already exists ###
$managedPath = Get-SPManagedPath -identity $siteManagedPath -HostHeader -ErrorAction Ignore;

### If the managed path does not exist create it, and continue creating the site ###
if($managedPath -eq $null){
    $managedPath = New-SPManagedPath $siteManagedPath -HostHeader;
    Write-Host "Following manage path was added to the HostHeader: " -ForegroundColor Green -NoNewline;
    Write-Host $siteManagedPath -ForegroundColor Yellow;
}

### Put the URL together ###
$site = $rootSite+'/'+$siteManagedPath+'/'+$sitePath;

### Create Host Named SiteCollection SPSite ###
Write-Host "Creating Host named site collection -> $site" -ForegroundColor Magenta -BackgroundColor Black;
Try{    
    $newSpSite = New-SPSite $site  -HostHeaderWebApplication $WebApp -Name $Name -Description $Description  -OwnerAlias $Owner -language $Language -Template $Template -ContentDatabase $ContentDB -ErrorAction Stop;
    
    <### Insert default permission groups ###>
    $web=$newSpSite.RootWeb
    $web.AssociatedOwnerGroup = $null
    $web.AssociatedMemberGroup = $null
    $web.AssociatedVisitorGroup = $null
    $web.CreateDefaultAssociatedGroups($newSpSite.Site.Owner.UserLogin, $newSpSite.Site.SecondaryContact.UserLogin, $newSpSite.Title)

    Write-Host "Host named site collection created. Visit is on -> $site" -ForegroundColor Magenta -BackgroundColor Black;
}
Catch{
    $ErrorMessage = $_.Exception.Message;
    $FailedItem = $_.Exception.ItemName;        
    Write-Error -Message $ErrorMessage;
    break;     
}

### Add additional site collection admins ###
foreach ($siteCollectionAdmin in $siteCollectionAdmins) 
{
    $siteCollectionAdmin = New-SPUser -UserAlias $siteCollectionAdmin -Web $site -SiteCollectionAdmin;    
    Write-Host "Following Site Collection Admin was added to the site -> " -ForegroundColor Green -BackgroundColor Black -NoNewline;
    Write-Host $siteCollectionAdmin.DisplayName -ForegroundColor Yellow -BackgroundColor Black;

}

### Enable/Disable feature ###
Disable-SPFeature -Identity "MDSFeature" -Url $site -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
Write-Host "Following feature was disabled: " -ForegroundColor Green -NoNewline;
Write-Host "MDSFeature (Minimal Download stragety)" -ForegroundColor Yellow;
 