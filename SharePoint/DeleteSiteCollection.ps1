﻿### Delete Host Named SiteCollection SPSite ###
Clear-Host

<# Load SharePoint PowerShell if not present #>
If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 


### Delete a site collection brute force way ###
$siteUrls = @("https://bgp.dev02.sp.ppro.bgnet.de/team/gmdev01","https://bgp.dev02.sp.ppro.bgnet.de/team/gmdev02");
foreach ($siteUrl in $siteUrls) 
{
	Write-Host "Deleting site -> $siteUrl" -ForegroundColor Yellow -BackgroundColor Black;
    $site = get-spsite $siteUrl -ErrorAction SilentlyContinue;
    if($site){
    	$siteId = $site.Id;
	    $siteDatabase = $site.ContentDatabase;
	    $siteDatabase.ForceDeleteSite($siteId, $false, $false);
        Write-Host "Following site was deleted -> $siteUrl" -ForegroundColor Green -BackgroundColor Black;
    }else{
        Write-Host "Site not found -> $siteUrl" -ForegroundColor Magenta -BackgroundColor Black;
    }
}
