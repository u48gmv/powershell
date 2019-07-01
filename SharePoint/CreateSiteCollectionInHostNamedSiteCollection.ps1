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
$WebApp = "http://sp2019vm";
$rootSite = "http://portal.dev-gmv.bgnet.de"; ## This Host named site collection needs to exist. NOTE: No leading or trailing slashes
$ContentDB ="WSS_Content_096bc88ec8dc4b4585d30f903f45a63a";
$DefaultAdmins = @("ppro\sp48backupadm"); ## Theese Administrators will be added to each site.
#$sitePath = "bgint03"; ### The new site collection beneath the managed path "team. NOTE: No leading or trailing slashes"
#$siteManagedPath = "teamsites" ### The managed path to use. NOTE: No leading or trailing slashes ##
#$Owner = "dev-gmv\u48gmv";
#$Name ="BG Interessenvertreter 03";
#$Description ="Demo Interessenvertreter Seite";
#$siteCollectionAdmins = @("ms\u48pru","ms\u48wst","ms\u48gmv","ms\u480tbs","ms\u48hhh","ms\u48mll","ms\u48gsc","ms\u48rqa","ms\u48lpd","ppro\sp48backupadm");
#$siteCollectionAdmins = @("dev-gmv\bguser");
<## Example site to create
[PSCustomObject]@{
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
        Template = "SITEPAGEPUBLISHING#0";
        Language = 1031;
        SitePath = "bgproj04";
        SiteManagedPath ="teamsites";
        Owner = "dev-gmv\u48gmv";
        Title = "BG Projekt 04";
        Description = "Demo Projekt Seite";
        Admins = @("dev-gmv\bgadmin")+$DefaultAdmins;
    },
    [PSCustomObject]@{
        Template = "SITEPAGEPUBLISHING#0";
        Language = 1031;
        SitePath = "bgproj05";
        SiteManagedPath ="teamsites";
        Owner = "dev-gmv\u48gmv";
        Title = "BG Projekt 05";
        Description = "Demo Projekt Seite";
        Admins = @("dev-gmv\bgadmin")+$DefaultAdmins;
    },
    [PSCustomObject]@{
        Template = "SITEPAGEPUBLISHING#0";
        Language = 1031;
        SitePath = "bgproj06";
        SiteManagedPath ="teamsites";
        Owner = "dev-gmv\u48gmv";
        Title = "BG Projekt 06";
        Description = "Demo Projekt Seite";
        Admins = @("dev-gmv\bgadmin")+$DefaultAdmins;
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
    $site = $rootSite+'/'+$siteToCreate.SiteManagedPath+'/'+$siteToCreate.SitePath;

    ### Create Host Named SiteCollection SPSite ###
    Write-Host "Creating Host named site collection -> $site" -ForegroundColor Magenta -BackgroundColor Black;
    Try{    
        $newSpSite = New-SPSite $site  -HostHeaderWebApplication $WebApp -Name $siteToCreate.Title -Description $siteToCreate.Description  -OwnerAlias $siteToCreate.Owner -language $siteToCreate.Language -Template $siteToCreate.Template -ContentDatabase $ContentDB -ErrorAction Stop;
        
        <### Insert default permission groups
        $web=$newSpSite.RootWeb
        $web.AssociatedOwnerGroup = $null
        $web.AssociatedMemberGroup = $null
        $web.AssociatedVisitorGroup = $null
        $web.CreateDefaultAssociatedGroups($newSpSite.Site.Owner.UserLogin, $newSpSite.Site.SecondaryContact.UserLogin, $newSpSite.Title)
        ###>

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



 