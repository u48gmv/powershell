### Import a Site ###
Clear-Host

### Init parameters ###
#### Connection settings ####
$SiteUrl = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs";
$UserName = "ppro\sp48spsetupdev02";
$Password = "";
$snapInsToAdd = @("Microsoft.SharePoint.Powershell");
$foundError = $false;

#### App settings ####
$Template="BLANKINTERNET#0"; ### Publishing site
$Language = 1031; ### German
$importFile = "D:\u48gmv\imports\iewibs\subsite.xml";
$baseURL = "/team/iewibs/";

#### Define multiple webs ###
### Each web has the following structure ####
### [pscustomobject]@{template="THE TEMPLATE TO USE FOR THE SUBSITE";language="THE LANGUAGE FOR THE SUBSITE";url="THE URL OF THE SUBSITE";title="THE TITLE OF THE SUBSITE";description="THE DESCRIPTION OF THE SUBSIE"} ###
### Copy paste the above line into the $webs variable in order to create multiple subsites
$webs=@(
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL;
                      url="bgrci";
                      title="BG RCI";
                      description="BG RCI Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL;
                      url="guso-uk-nrw";
                      title="GUSO UK NRW";
                      description="GUSO UK NRW Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL;
                      url="mignotes";
                      title="Mignotes";
                      description="Mignotes Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL+"mignotes/";
                      url="bgbau";
                      title="BG BAU";
                      description="BG BAU Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL+"mignotes/";
                      url="guso-uk";
                      title="GUSO UK";
                      description="GUSO UK Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL+"mignotes/";
                      url="mdm";
                      title="MDM";
                      description="MDM Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      basePath=$baseURL;
                      url="spservice";
                      title="SharePoint";
                      description="SharePoint Projekt"}
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



### Start logic for creating the sub sites  ###
Write-Host $webs.Count -ForegroundColor Cyan -NoNewline;
Write-Host " sub sites will be created.`n`r" -ForegroundColor Cyan;

foreach($web in $webs){

    ### Create Host Named SiteCollection SPWeb ###
    $retry = 10;
    while($retry -gt 0){
        Try{    
        
            ### Create the sub site ###
            Write-Host "Creating sub site -> " -ForegroundColor Yellow -NoNewline;
            Write-Host $web.title -ForegroundColor Green;

            $baseWeb = Get-PnPWeb -Identity $web.basePath;
            $newSpWeb = New-PnPWeb -Title $web.title -Url $web.url -Template $web.template -Description $web.description -Locale $web.language -Web $baseWeb -ErrorAction Stop;
        
            Write-Host "New sub site created. Visit is on -> " -ForegroundColor Yellow -NoNewline;
            Write-Host $newSpWeb.url -ForegroundColor Green;
            $retry = 0;
            $foundError = $false;
        }
        Catch{
            $ErrorMessage = $_.Exception.Message;
            $FailedItem = $_.Exception.ItemName;        
            Write-Error -Message $ErrorMessage;            
            $foundError = $true;
            $retry--;
            Write-Host "Creation of sub site " + $web.title + "failed. Will retry another $retry times" -ForegroundColor DarkYellow;
        }
    }

    if(!$foundError){
        Try{
            ### Apply the template for a standard site ###
            Write-Host "Start applying site template to --> " $newSpWeb.url -ForegroundColor Yellow;
            Apply-PnPProvisioningTemplate -Path $importFile -Web $newSpWeb -ErrorAction Stop;
            Write-Host "Done applying site template to --> " $newSpWeb.url -ForegroundColor Green;

            <###
            Remove unwanted content types 
            This step is needed as when new lists are created some default content types aer applied automatically
            ###>
            Write-Host "Removing content types" -ForegroundColor Yellow;
            Remove-PnPContentTypeFromList -List "Projektdokumente" -ContentType "Dokument" -Web $newSpWeb -ErrorAction Stop;
            Write-Host "Content types removed" -ForegroundColor Green;
        }
        Catch{
            $ErrorMessage = $_.Exception.Message;
            $FailedItem = $_.Exception.ItemName;        
            Write-Error -Message $ErrorMessage;
            $foundError = $true;
            break;        
        }    
    }
    if(!$foundError){
        ### Enable/Disable feature ###
        #Disable-SPFeature -Identity "MDSFeature" -Url $web.url -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
        Disable-PnPFeature -Identity "87294c72-f260-42f3-a41b-981a2ffce37a" -Web $baseWeb -Force -ErrorAction Ignore;  # Disable minimum download strategy feature
        Write-Host "Following feature was disabled: " -ForegroundColor Yellow -NoNewline;
        Write-Host "MDSFeature (Minimal Download stragety)`n`r" -ForegroundColor Green;    
    }    
}

if($foundError){
    Write-Host "Error occured. See message above." -ForegroundColor Red;
}else{
    Write-Host "Done creating sub sites." -ForegroundColor Cyan;
}




##### DO SOMETHING WITH THE SITE END #####


### Close Conenction ###
Write-Host "Disconnecting from $SiteUrl" -ForegroundColor Yellow;
Disconnect-PnPOnline -Connection $connection;
Write-Host "Disconnected from $SiteUrl" -ForegroundColor Green;

