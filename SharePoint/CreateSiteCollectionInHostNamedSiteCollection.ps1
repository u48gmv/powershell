### Create a website on a Host Named Sitecollection using managed paths ###
clear-host

### Add SharePoint Snap In ###
<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 



### Init ###
### Init parameters ###
#$Template="STS#0"; ### Team site
#$Template="BLANKINTERNET#0"; ### Publishing site
#$Template="DEV#0"; ### Developer site
#$Template="STS#0"; ### Standard team site
#$Template="STS#3"; ### Modern team site
#$Template="SITEPAGEPUBLISHING#0"; ### Communication Site
#$Language = 1031; ### German
$WebApp = "https://ab.sp.ppro.bgnet.de/";
$rootSite = "https://portal.ab.sp.ppro.bgnet.de"; ## This Host named site collection needs to exist. NOTE: No leading or trailing slashes
$ContentDB ="AB_Content_Portal_001";
$DefaultAdmins = @("ppro\sp48backupadm");

<## Example site to create
[PSCustomObject]@{
    WebApp=$WebApp;
    RootSite=$rootSite;
    ContentDb=$ContentDB;
    Template = "SITEPAGEPUBLISHING#0";
    Language = 1031;
    SitePath = "bgproj04";
    SiteManagedPath ="teamsites";
    Owner = "dev-gmv\u48gmv";
    Title = "BG Projekt 04";
    Description = "Demo Projekt Seite";
    Admins = @("dev-gmv\bgadmin")+$DefaultAdmins;
}
##>

$sitesToCreate = @(
    [PSCustomObject]@{
        WebApp=$WebApp;
        RootSite=$rootSite;
        ContentDb=$ContentDB;
        Template = "SITEPAGEPUBLISHING#0";
        Language = 1031;
        SitePath = "app01";
        SiteManagedPath ="app";
        Owner = "ppro\SP48SPSETUPABNAHME";
        Title = "App 01";
        Description = "Demosite für App 01";
        Admins = @("ms\u48gmv")+$DefaultAdmins;
    }
);
### Runtime variables ###
$errorOccured = $true;
$ErrorMessage = "";
$FailedItem = ""; 


### Start logic for creating site collection  ###

foreach($siteToCreate in $sitesToCreate){
    ### Check if the managed path already exists ###
    $managedPath = Get-SPManagedPath -identity $siteToCreate.SiteManagedPath -HostHeader -ErrorAction Ignore;

    ### If the managed path does not exist create it, and continue creating the site ###
    if($managedPath -eq $null){
        $managedPath = New-SPManagedPath $siteToCreate.SiteManagedPath -HostHeader;
        Write-Host "Following manage path was added to the HostHeader: " -ForegroundColor Green -NoNewline;
        Write-Host $siteToCreate.SiteManagedPath -ForegroundColor Yellow;
    }

    ### Put the URL together ###
    $site = $siteToCreate.RootSite+'/'+$siteToCreate.SiteManagedPath+'/'+$siteToCreate.SitePath;

    ### Create Host Named SiteCollection SPSite ###
    Write-Host "Creating Host named site collection -> $site" -ForegroundColor Magenta -BackgroundColor Black;
    Try{    
        $newSpSite = New-SPSite $site  -HostHeaderWebApplication $siteToCreate.WebApp -Name $siteToCreate.Title -Description $siteToCreate.Description  -OwnerAlias $siteToCreate.Owner -language $siteToCreate.Language -Template $siteToCreate.Template -ContentDatabase $siteToCrate.ContentDb -ErrorAction Stop;
        
        Write-Host "Host named site collection created. Visit is on -> $site" -ForegroundColor Magenta -BackgroundColor Black;
        $errorOccured = $false;
    }
    Catch{
        $ErrorMessage = $_.Exception.Message;
        $FailedItem = $_.Exception.ItemName;
        $errorOccured = $true;     
    }


    ### Only continue if no error occured ###
    if($errorOccured){
        Write-Error -Message $ErrorMessage;
        Write-Host "Due to an error the script was halted" -ForegroundColor Red;
    }else{
        ### Add additional site collection admins ###
        foreach ($siteCollectionAdmin in $siteToCreate.Admins) 
        {
            $siteCollectionAdmin = New-SPUser -UserAlias $siteCollectionAdmin -Web $site -SiteCollectionAdmin;    
            Write-Host "Following Site Collection Admin was added to the site -> " -ForegroundColor Green -BackgroundColor Black -NoNewline;
            Write-Host $siteCollectionAdmin.DisplayName -ForegroundColor Yellow -BackgroundColor Black;

        }

        ### Enable/Disable feature ###
        Disable-SPFeature -Identity "MDSFeature" -Url $site -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
        Write-Host "Following feature was disabled: " -ForegroundColor Green -NoNewline;
        Write-Host "MDSFeature (Minimal Download stragety)" -ForegroundColor Yellow;
        write-host "";
    }

}
