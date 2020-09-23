### Create  sub sites ###
clear-host

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";

### Init parameters ###
$Template="BLANKINTERNET#0"; ### Publishing site
$Language = 1031; ### German
$baseURL = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs/";
$foundError = $false;

#### Define multiple webs ###
### Each web has the following structure ####
### [pscustomobject]@{template="THE TEMPLATE TO USE FOR THE SUBSITE";language="THE LANGUAGE FOR THE SUBSITE";url="THE URL OF THE SUBSITE";title="THE TITLE OF THE SUBSITE";description="THE DESCRIPTION OF THE SUBSIE"} ###
### Copy paste the above line into the $webs variable in order to create multiple subsites
$webs=@(
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"bgrci";
                      title="BG RCI";
                      description="BG RCI Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"guso-uk-nrw";
                      title="GUSO UK NRW";
                      description="GUSO UK NRW Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"mignotes";
                      title="Mignotes";
                      description="Mignotes Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"mignotes/bgbau";
                      title="BG BAU";
                      description="BG BAU Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"mignotes/guso-uk";
                      title="GUSO UK";
                      description="GUSO UK Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"mignotes/mdm";
                      title="MDM";
                      description="MDM Projekt"},
    [pscustomobject]@{template=$Template;
                      language=$Language;
                      url=$baseURL+"spservice";
                      title="SharePoint";
                      description="SharePoint Projekt"}
);


### Start logic for creating the sub sites  ###
Write-Host $webs.Count -ForegroundColor Cyan -NoNewline;
Write-Host " sub sites will be created.`n`r" -ForegroundColor Cyan;

foreach($web in $webs){

    ### Create Host Named SiteCollection SPSite ###
    Write-Host "Creating sub site -> " -ForegroundColor Yellow -NoNewline;
    Write-Host $web.title -ForegroundColor Green;
    Try{    
        $newSpWeb = New-SPWeb $web.url -Template $web.template -Name $web.title -Description $web.description -AddToTopNav -Language $web.language -UseParentTopNav -Confirm:$false -ErrorAction Stop;
        Write-Host "New sub site created. Visit is on -> " -ForegroundColor Yellow -NoNewline;
        Write-Host $web.url -ForegroundColor Green;
    }
    Catch{
        $ErrorMessage = $_.Exception.Message;
        $FailedItem = $_.Exception.ItemName;        
        Write-Error -Message $ErrorMessage;
        $foundError = $true;
        break;     
    }

    ### Enable/Disable feature ###
    Disable-SPFeature -Identity "MDSFeature" -Url $web.url -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
    Write-Host "Following feature was disabled: " -ForegroundColor Yellow -NoNewline;
    Write-Host "MDSFeature (Minimal Download stragety)`n`r" -ForegroundColor Green;    
}

if($foundError){
    Write-Host "Error occured. See message above." -ForegroundColor Red;
}else{
    Write-Host "Done creating sub sites." -ForegroundColor Cyan;
}

