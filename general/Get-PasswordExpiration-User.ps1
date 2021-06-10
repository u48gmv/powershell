clear-host


#$accounts = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" -SearchBase "OU=Laptop,OU=BG-Phoenics,OU=Benutzer,DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object DisplayName
$accounts = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" -SearchBase "OU=UK Nord,OU=GUSO,OU=Benutzer,DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object DisplayName


foreach($account in $accounts){
    $expirationDate = [datetime]::FromFileTime($account."msDS-UserPasswordExpiryTimeComputed").ToString("dd/MM/yyyy")
    $displayName = $account.DisplayName
    write-host $displayName $expirationDate
        
}



-spurl="https://intra-ukn.ppro.bgnet.de/" -listname="kntkkontakte" -adou="OU=Migration,OU=UK-Nord,DC=ppro,DC=bgnet,DC=de" -filter="(&(objectCategory=person)(sAMAccountName=u*)(!sAMAccountName=u77oa*)(!sAMAccountName=u77es*)(!department=*extern*))" -type="full"



Erfahrungsaustausch Gefahrstoffe
TR AP-Ausbildung
TR Arbeitsschutzorganisation AMS BAU
TR Aus- und Fortbildung
TR BEM
TR BV Süd RLS
TR Hochschulbeauftragte BG BAU
TR Personal
TR Personalentwicklung BG BAU
TR Präv BK
TR Präv Messtechnik
TR Präv SuQ
TR SAP-HCM
TR Unfallauswertung
TR-MIG-DEAKT