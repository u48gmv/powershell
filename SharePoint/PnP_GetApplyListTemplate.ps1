clear-host
$AllProtocols = [System.Net.SecurityProtocolType]'Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

#$url="https://portal.ab.sp.ppro.bgnet.de/app/app01/sabb01"
$url="https://portal.ab.sp.ppro.bgnet.de/app/appdefault/appteam"

$connection = Connect-PnPOnline -Url $url -CurrentCredentials -ReturnConnection
#Get-PnPProvisioningTemplate -out lists_2019_full.xml -Handlers Lists
Apply-PnPProvisioningTemplate -Path "D:\TEST\ListExtract\BefundListe.xml" -Parameters @{"ListTitle"="BefundListe"}
#Apply-PnPProvisioningTemplate -Path "D:\TEST\ListExtract\lists_2019.xml" -Parameters @{"ListTitle"="TestBefundListe"}
