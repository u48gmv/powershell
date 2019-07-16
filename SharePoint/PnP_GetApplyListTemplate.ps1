$AllProtocols = [System.Net.SecurityProtocolType]'Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

$url="https://bg-phoenics.test.sp.ppro.bgnet.de/webseiten/ibsiew/mn"
#$url="https://portal.ab.sp.ppro.bgnet.de/teamsite/bggremium"

$connection = Connect-PnPOnline -Url $url -CurrentCredentials -ReturnConnection
Get-PnPProvisioningTemplate -out lists_2016_full.xml -Handlers Lists
#Apply-PnPProvisioningTemplate -Path "D:\TEST\ListExtract\BefundListe_2019.xml" -Parameters @{"ListTitle"="TestBefundListe"}
#Apply-PnPProvisioningTemplate -Path "D:\TEST\ListExtract\lists_2019.xml" -Parameters @{"ListTitle"="TestBefundListe"}
