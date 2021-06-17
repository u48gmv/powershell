#$accounts = Get-ADUser -filter {userAccountControl -eq 514 -and objectCategory -eq "person" -and samAccountName -like "u48*"} –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" -SearchBase "DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object DisplayName
$accounts = Get-ADUser -filter {userAccountControl -eq 514 -and objectCategory -eq "person" -and samAccountName -like "u48*"} -Properties "samAccountName" -SearchBase "DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object samAccountName
write-host "Found $($accounts.Count) inactive account"
<#
foreach($account in $accounts){
    write-host $account.samAccountName
}
#>

Get-ADUser -filter {userAccountControl -eq 514 -and objectCategory -eq "person" -and samAccountName -like "u48*"} -Properties "samAccountName" -SearchBase "DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object samAccountName | ForEach-Object -Process {Write-Host $_.samaccountname} | Out-File -FilePath .\test.txt
Get-ADUser -filter {userAccountControl -eq 514 -and objectCategory -eq "person" -and samAccountName -like "u48*"} -Properties "samAccountName" -SearchBase "DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object samAccountName | ForEach-Object -Process { $_.samaccountname | Out-File -Append -FilePath .\InactiveBGPhoenicsAccounts.txt}

Get-ADUser -filter {Enabled -eq $False} -Properties "samAccountName" -SearchBase "DC=ms,DC=bgnet,DC=de" -Server ms.bgnet.de | Sort-Object samAccountName | ForEach-Object -Process { $_.samaccountname | Out-File -Append -FilePath .\InactiveBGAllAccounts.txt}
#Enabled -eq $True