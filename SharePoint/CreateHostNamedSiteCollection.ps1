### Create Host Named SiteCollection SPSite ###
Clear-Host
### Add SharePoint Snap In ###
<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

### Init parameters ###
#$Template="BLANKINTERNET#0"; ### Publishing site
#$Template="DEV#0"; ### Developer site
#$Template="STS#0"; ### Standard team site
#$Template="STS#3"; ### Standard team site modern
$Template="SITEPAGEPUBLISHING#0" ### Communication site
$Language = 1031; ### Deutsch
$WebApp = "http://sp2019vm/";
$URL = "http://portal.dev-gmv.bgnet.de/";
$Owner = "dev-gmv\u48gmv";
$Name ="BG Portal";
$Description ="Das Portal der BGen";
$ContentDB ="WSS_Content_096bc88ec8dc4b4585d30f903f45a63a"
$siteCollectionAdmins = @("dev-gmv\adadmin","dev-gmv\bguser");


### Create Host Named SiteCollection SPSite ###
$site = New-SPSite -URL $URL –HostHeaderWebApplication $WebApp  -OwnerAlias $Owner -Language $Language -Template $Template -Name $Name -Description $Description  -ContentDatabase $ContentDB  
Write-Host "Host named site collection created. Visit is on -> $URL" -ForegroundColor Magenta -BackgroundColor Black;

### Set default groups ###
Write-Host "Creating default groups..." -ForegroundColor Yellow;
Try{
    $site=get-spsite $URL -ErrorAction Stop;
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
Write-Host "Done creating default groups" -ForegroundColor Yellow;

### Add additional site collection admins ###
Write-Host "Adding additional site collection admins" -ForegroundColor Yellow;
foreach ($siteCollectionAdmin in $siteCollectionAdmins) 
{
    $siteCollectionAdmin = New-SPUser -UserAlias $siteCollectionAdmin -Web $URL -SiteCollectionAdmin;    
    Write-Host "Following Site Collection Admin was added to the site -> " -ForegroundColor Green -BackgroundColor Black -NoNewline;
    Write-Host $siteCollectionAdmin.DisplayName -ForegroundColor Yellow -BackgroundColor Black;
}
Write-Host "Done adding additional site collection admins" -ForegroundColor Green;

### Enable/Disable feature ###
Disable-SPFeature -Identity "MDSFeature" -Url $URL -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
Write-Host "Note: Feature Minimale Downloadstrategie was deactivated." -ForegroundColor Yellow;
