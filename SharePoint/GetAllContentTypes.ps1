﻿### Import a Site ###
Clear-Host
### Init parameters ###
$SiteUrl = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs/bgrci";
$UserName = "ppro\sp48spsetupdev02";
$Password = "";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$importFile = "D:\u48gmv\imports\iewibs\subsite.xml"


### Add Snap Ins if not already loaded ###
foreach ($snapInToAdd in $snapInsToAdd) 
{
    if ( $null -eq (Get-PSSnapin -Name $snapInToAdd -ErrorAction SilentlyContinue))
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



$contentType = Get-PnPContentType -List "Projektdokumente"-Connection $connection;
$contentType
Write-Host "";


##### DO SOMETHING WITH THE SITE END #####


### Close Conenction ###
Write-Host "Disconnecting from $SiteUrl" -ForegroundColor Yellow;
Disconnect-PnPOnline -Connection $connection;
Write-Host "Disconnected from $SiteUrl" -ForegroundColor Green;
