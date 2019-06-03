### Export a Site ###
cls
### Init parameters ###
<## DEV 02 Export
$SiteUrl = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs";
$UserName = "ppro\sp48spsetupdev02";
$Password = "Dj3mrc8-vJCY";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$exportFile = "D:\u48gmv\exports\iewibs_team\team-landing-site_dev02.xml"
##>

<## DEV 01 Export
$SiteUrl = "https://bgp.dev01.sp.ppro.bgnet.de/team/iewibs";
$UserName = "ppro\sp48spsetupdev01";
$Password = "wjX7iFATHVfh";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$exportFile = "D:\u48gmv\exports\iewibs_team\team-landing-site_dev01.xml"
 ##>
 
<## DEV 02 Test Exports ##>
$SiteUrl = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs";
$UserName = "ppro\sp48spsetupdev02";
$Password = "Dj3mrc8-vJCY";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$exportFile = "D:\u48gmv\exports\testing-exp\team-landing-site_dev02.xml"




### Add Snap Ins if not already loaded ###
foreach ($snapInToAdd in $snapInsToAdd) 
{
    if ( (Get-PSSnapin -Name $snapInToAdd -ErrorAction SilentlyContinue) -eq $null )
    {
        Add-PsSnapin $snapInToAdd;
        Write-Host "$snapInToAdd loaded" -ForegroundColor Green;

    }else{
        
        Write-Host "$snapInToAdd already loaded" -ForegroundColor Magenta;

    }
}

# Connect to the site
$PasswordAsSecure = ConvertTo-SecureString $Password -AsPlainText -Force;
$Credentials = New-Object System.Management.Automation.PSCredential ($UserName , $PasswordAsSecure);
Write-Host "Connecting to $SiteUrl" -ForegroundColor Yellow;
$connection = Connect-PnPOnline -Url $SiteUrl -Credentials $Credentials -IgnoreSslErrors -ReturnConnection;
Write-Host "Connected to $SiteUrl" -ForegroundColor Green;

##### DO SOMETHING WITH THE SITE START #####



### Export the site ###
Write-Host "Start exporting $SiteUrl" -ForegroundColor Yellow;
#Export-SPWeb $SiteUrl -Path $exportedFile -Force;
Get-PnPProvisioningTemplate -IncludeAllTermGroups -Out $exportFile
#Get-PnPProvisioningTemplate -Out $exportFile  -IncludeAllTermGroups -PersistBrandingFiles -PersistPublishingFiles -IncludeNativePublishingFiles -IncludeSiteGroups
Write-Host "Done exporting $SiteUrl" -ForegroundColor Green;
Write-Host "Export location -> $exportFile" -ForegroundColor Green;



##### DO SOMETHING WITH THE SITE END #####


### Close Conenction ###
Write-Host "Disconnecting from $SiteUrl" -ForegroundColor Yellow;
Disconnect-PnPOnline -Connection $connection;
Write-Host "Disconnected from $SiteUrl" -ForegroundColor Green;

