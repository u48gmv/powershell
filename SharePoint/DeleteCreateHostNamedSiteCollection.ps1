### Delete and create Host Named SiteCollection SPSite ###
Clear-Host
<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }


### Init parameters ###
$Template="BLANKINTERNET#0"; ### Veröffentlichungssite
$Language = 1031; ### Deutsch
$WebApp = "http://dev02.sp.ppro.bgnet.de/";
$URL = "https://iewibs.dev02.sp.ppro.bgnet.de/";
$Owner = "ppro\sp48spsetupdev02";
$Name ="IEW IBS Teamraum";
$Description ="Ein Kollaborationsraum für IEW und IBS";
$ContentDB ="DEV02_Content_Portal_001"
$siteCollectionAdmins = @("ms\u48gmv","ms\u48pru","ms\u480tbs","ms\u48hhh","ms\u48mll","ms\u48gsc","ms\u48lpd");


### Delete a site collection brute force way ###
$siteUrls = @($URL);
foreach ($siteUrl in $siteUrls) 
{
	$site = get-spsite $siteUrl;
	$siteId = $site.Id;
	$siteDatabase = $site.ContentDatabase;
	$siteDatabase.ForceDeleteSite($siteId, $false, $false);
    Write-Host "Following site was deleted -> $siteUrl" -ForegroundColor Magenta -BackgroundColor Black;
}

### Create Host Named SiteCollection SPSite ###
$site = New-SPSite -URL $URL –HostHeaderWebApplication $WebApp  -OwnerAlias $Owner -Language $Language -Template $Template -Name $Name -Description $Description  -ContentDatabase $ContentDB  
Write-Host "Host named site collection created. Visit is on -> $URL" -ForegroundColor Magenta -BackgroundColor Black;

### Add additional site collection admins ###

foreach ($siteCollectionAdmin in $siteCollectionAdmins) 
{
    $siteCollectionAdmin = New-SPUser -UserAlias $siteCollectionAdmin -Web $URL -SiteCollectionAdmin;    
    Write-Host "Following Site Collection Admin was added to the site -> " -ForegroundColor Green -BackgroundColor Black -NoNewline;
    Write-Host $siteCollectionAdmin.DisplayName -ForegroundColor Yellow -BackgroundColor Black;

}

### Enable/Disable feature ###
Disable-SPFeature -Identity "MDSFeature" -Url $URL -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
