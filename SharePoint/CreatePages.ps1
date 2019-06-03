### Export a Site ###
cls
### Init parameters ###
$WebApp = "http://dev02.sp.ppro.bgnet.de/";
$SiteUrl = "http://bgp.dev02.sp.ppro.bgnet.de/";
$UserName = "ppro\sp48spsetupdev02";
$Password = "Dj3mrc8-vJCY";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$siteCollectionAdmins = @("ms\u48gmv","ms\u48pru","ms\u480tbs","ms\u48hhh","ms\u48mll","ms\u48gsc");
$folderToPublish = "/Seiten";
$importFile = "D:\u48gmv\imports\bgpStarterIntranet\bgpStarterIntranetTest.xml";


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



### Create some pages on the site ###
Write-Host "Start creating pages" -ForegroundColor Yellow;
Add-PnPPublishingPage -PageName "myNewPage" -Title "Some nice title" -PageTemplateName "ArticleLeft" -Folder $folderToPublish -Publish -Connection $connection -Verbose -Debug;
Write-Host "Done creating pages" -ForegroundColor Green;

### Apply a template ###
Write-Host "Start applying template $importFile" -ForegroundColor Yellow;
Apply-PnPProvisioningTemplate -Path $importFile -Verbose -Debug;
Write-Host "Done applying template $importFile" -ForegroundColor Green;




##### DO SOMETHING WITH THE SITE END #####


### Close Conenction ###
Write-Host "Disconnecting from $SiteUrl" -ForegroundColor Yellow;
Disconnect-PnPOnline -Connection $connection;
Write-Host "Disconnected from $SiteUrl" -ForegroundColor Green;

