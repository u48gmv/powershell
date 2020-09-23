### Delete sub sites ###
Clear-Host

<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 


### Init parameters ###

#### Connection settings ####
$SiteUrl = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs";
$UserName = "ppro\sp48spsetupdev02";
$Password = "";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$foundError = $false;

#### App settings ####
$baseURL = "/team/iewibs/";

#### Define multiple webs ###
$webs=@(
    [pscustomobject]@{basePath=$baseURL;
                      url="bgrci"},
    [pscustomobject]@{basePath=$baseURL;
                      url="guso-uk-nrw"},
    [pscustomobject]@{basePath=$baseURL+"mignotes/";
                     url="bgbau"},
    [pscustomobject]@{basePath=$baseURL+"mignotes/";
                      url="guso-uk"},
    [pscustomobject]@{basePath=$baseURL+"mignotes/";
                      url="mdm"},
    [pscustomobject]@{basePath=$baseURL;
                      url="mignotes"},
    [pscustomobject]@{basePath=$baseURL;
                      url="spservice"}
);


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

### Start logic for deleting the sub sites  ###
Write-Host $webs.Count -ForegroundColor Cyan -NoNewline;
Write-Host " sub sites will be deleted.`n`r" -ForegroundColor Cyan;

foreach($web in $webs){

    $fullWebUrl = $web.basePath+$web.url;

    ### Create Host Named SiteCollection SPSite ###
    Write-Host "Deleting sub site -> " -ForegroundColor Yellow -NoNewline;
    Write-Host $fullWebUrl -ForegroundColor Green;
 
    Try{
        $baseWebId = (Get-PnPWeb -Identity $fullWebUrl).Id;
        $webTitle = $baseWeb.title;        
        
        $delSpWeb = Remove-PnPWeb -Identity $baseWebId -Force -ErrorAction Stop
        Write-Host "Following sub site was deleted -> " -ForegroundColor Yellow -NoNewline;
        Write-Host $webTitle "`n`r" -ForegroundColor Green;
    }
    Catch{
        $ErrorMessage = $_.Exception.Message;
        $FailedItem = $_.Exception.ItemName;        
        Write-Error -Message $ErrorMessage;
        $foundError=$true;
        break;             
    }
 

}
if($foundError){
    Write-Host "Error occured. See message above." -ForegroundColor Red;
}else{
    Write-Host "Done deleting sub sites." -ForegroundColor Cyan;
}


##### DO SOMETHING WITH THE SITE END #####


### Close Conenction ###
Write-Host "Disconnecting from $SiteUrl" -ForegroundColor Yellow;
Disconnect-PnPOnline -Connection $connection;
Write-Host "Disconnected from $SiteUrl" -ForegroundColor Green;


