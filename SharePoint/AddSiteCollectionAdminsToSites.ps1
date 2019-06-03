### Add additional site collection admins to each provided site###
clear-host

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";


### Init ###
$siteCollectionAdmins = @("ms\u48gmv");
$sites = @("https://bg-phoenics.test.sp.ppro.bgnet.de/webseiten/SPM");

foreach($site in $sites)
{
    Write-Host "Processing site collection admins for the following site collection: " -ForegroundColor Green -NoNewline;
    Write-Host $site -ForegroundColor Yellow;

    foreach ($siteCollectionAdmin in $siteCollectionAdmins) 
    {
        $siteCollectionAdmin = New-SPUser -UserAlias $siteCollectionAdmin -Web $site -SiteCollectionAdmin;    
        Write-Host "Following Site Collection Admin was added to the site -> " -ForegroundColor Green -NoNewline;
        Write-Host $siteCollectionAdmin.DisplayName -ForegroundColor Yellow;

    }

    Write-Host "Done Processing site collection admins for the following site collection: " -ForegroundColor Green -NoNewline;
    Write-Host $site -ForegroundColor Yellow;
}
