clear-host


#$accounts = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" -SearchBase "OU=Laptop,OU=BG-Phoenics,OU=Benutzer,DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object DisplayName
$accounts = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" -SearchBase "OU=UK Nord,OU=GUSO,OU=Benutzer,DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object DisplayName


foreach($account in $accounts){
    $expirationDate = [datetime]::FromFileTime($account."msDS-UserPasswordExpiryTimeComputed").ToString("dd/MM/yyyy")
    $displayName = $account.DisplayName
    write-host $displayName $expirationDate
        
}





