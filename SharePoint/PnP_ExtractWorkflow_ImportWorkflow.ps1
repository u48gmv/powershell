Clear-Host
<#
$SiteUrl = "https://ssp.dev02.sp.ppro.bgnet.de/";
$UserName = "ppro\sp48spsetupdev02";
$Password = "Dj3mrc8-vJCY";

# Connect to the site
$PasswordAsSecure = ConvertTo-SecureString $Password -AsPlainText -Force;
$Credentials = New-Object System.Management.Automation.PSCredential ($UserName , $PasswordAsSecure);
Write-Host "Connecting to $SiteUrl" -ForegroundColor Yellow;
$connection = Connect-PnPOnline -Url $SiteUrl -Credentials $Credentials -IgnoreSslErrors -ReturnConnection;
Write-Host "Connected to $SiteUrl" -ForegroundColor Green;
$wfDef = Get-PnPWorkflowDefinition -Name "sspApproval" | Export-Clixml -Path "./sspApproval.xml"

Get-PnPProvisioningTemplate -out template.xml



Disconnect-PnPOnline
#>

$SiteUrl = "https://bg-phoenics.test.sp.ppro.bgnet.de/webseiten/ibsiew";
$UserName = "ms\u48gmv";
$Password = "Admin-002";

# Connect to the site
$PasswordAsSecure = ConvertTo-SecureString $Password -AsPlainText -Force;
$Credentials = New-Object System.Management.Automation.PSCredential ($UserName , $PasswordAsSecure);
Write-Host "Connecting to $SiteUrl" -ForegroundColor Yellow;
$connection = Connect-PnPOnline -Url $SiteUrl -Credentials $Credentials -IgnoreSslErrors -ReturnConnection;
Write-Host "Connected to $SiteUrl" -ForegroundColor Green;

#Apply-PnPProvisioningTemplate -Path "./wf-import.xml"
Get-PnPProvisioningTemplate -Out workflow.xml -Handlers Workflows


Disconnect-PnPOnline

