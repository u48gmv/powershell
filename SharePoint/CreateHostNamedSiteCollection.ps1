### Create Host Named SiteCollection SPSite ###
Clear-Host
### Add SharePoint Snap In ###
<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

### Init parameters ###
#$Template="BLANKINTERNET#0"; ### Publishing site
#$Template="DEV#0"; ### Developer site
$Template="STS#0"; ### Standard team site
$Language = 1031; ### Deutsch
$WebApp = "http://dev02.sp.ppro.bgnet.de/";
$URL = "https://ssp.dev02.sp.ppro.bgnet.de/";
$Owner = "ppro\sp48spsetupdev02";
$Name ="Self Service Portal";
$Description ="Ein Portal zum Beantragen von verschiedenen Seiten";
$ContentDB ="DEV02_Content_Portal_001"
$siteCollectionAdmins = @("ms\u48gmv","ms\u48pru","ms\u480tbs","ms\u48hhh","ms\u48mll","ms\u48gsc","ms\u48lpd","ppro\sp48backupadm");


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
