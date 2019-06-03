
$SiteUrl = "https://bgbau.intra.dev01.sp.ppro.bgnet.de";
$UserName = "ms\u48gmv";
$Password = "Admin-004";
$PageUrl = "/Seiten/GMV-TEST.aspx";

Disconnect-PnPOnline

# Connect to the site
$PasswordAsSecure = ConvertTo-SecureString $Password -AsPlainText -Force;
$Credentials = New-Object System.Management.Automation.PSCredential ($UserName , $PasswordAsSecure);
Write-Host "Connecting to $SiteUrl" -ForegroundColor Yellow;
$connection = Connect-PnPOnline -Url $SiteUrl -Credentials $Credentials -IgnoreSslErrors -ReturnConnection;
Write-Host "Connected to $SiteUrl" -ForegroundColor Green;

$webPartId ="446010e9-93ae-41c9-810c-aa6439f7285b"

$webPart = get-pnpwebpartxml -ServerRelativePageUrl $PageUrl -Identity $webPartId

<#

https://bgbau.intra.dev01.sp.ppro.bgnet.de/_vti_bin/exportwp.aspx?pageurl=https://bgbau.intra.dev01.sp.ppro.bgnet.de/Seiten/GMV-TEST.aspx&guidstring=446010e9-93ae-41c9-810c-aa6439f7285b

#>