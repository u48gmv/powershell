### Delete sub sites ###
cls

### Add SharePoint Snap In ###
Add-PSSnapin "Microsoft.SharePoint.Powershell";


### Init parameters ###
$baseURL = "https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs/";
$foundError = $false;

#### Define multiple webs ###
$webs=@(
    [string]::Concat($baseURL,"bgrci/"),
    [string]::Concat($baseURL,"guso-uk-nrw/"),
    [string]::Concat($baseURL,"mignotes/bgbau/"),
    [string]::Concat($baseURL,"mignotes/guso-uk/"),
    [string]::Concat($baseURL,"mignotes/mdm/"),
    [string]::Concat($baseURL,"mignotes/"),
    [string]::Concat($baseURL,"spservice/")
);

### Start logic for creating the sub sites  ###
Write-Host $webs.Count -ForegroundColor Cyan -NoNewline;
Write-Host " sub sites will be deleted.`n`r" -ForegroundColor Cyan;

foreach($web in $webs){

    ### Create Host Named SiteCollection SPSite ###
    Write-Host "Deleting sub site -> " -ForegroundColor Yellow -NoNewline;
    Write-Host $web -ForegroundColor Green;
 
    Try{    
        $webTitle = (Get-SPWeb $web -ErrorAction Stop).title;
        $delSpWeb = Remove-SPWeb $web -Confirm:$false -ErrorAction Stop;
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


