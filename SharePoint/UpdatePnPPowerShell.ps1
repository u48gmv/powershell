###########################
##### Set init values #####
###########################

$proxy=$true

##################################
##### Proxy settings #############
##### Only needed in case ######## 
##### you are behind a proxy #####
##################################
if($proxy){
    $proxString = "http://10.48.201.38:8080"
    $proxyUri = [System.Uri]::new($proxString)
    [System.Net.WebRequest]::DefaultWebProxy = new-object System.Net.WebProxy ($proxyUri, $true)
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
}

Clear-Host

Write-Host "Current installed version" -ForegroundColor Yellow
Get-Module SharePointPnPPowerShell* -ListAvailable | Select-Object Name,Version | Sort-Object Version -Descending
Write-Host "Trying to update" -ForegroundColor Yellow
Update-Module SharePointPnPPowerShell*
Write-Host "Update executed" -ForegroundColor Green
Write-Host "Udpated version" -ForegroundColor Yellow
Get-Module SharePointPnPPowerShell* -ListAvailable | Select-Object Name,Version | Sort-Object Version -Descending
