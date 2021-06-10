<#
How to assign an alien tenant user
#>
Clear-Host

Add-PSSnapin Microsoft.SharePoint.PowerShell

$webApplicatioURL = Read-Host -Prompt "Provide the URL of the desired webapplication"

$wa1 = Get-SPWebApplication $webApplicatioURL

Write-Host "Clearing the PeoplePicker filter" -ForegroundColor Yellow

$wa1.PeoplePickerSettings.SearchActiveDirectoryDomains.Clear()
$wa1.Update()

Write-Host "PeoplePicker filter cleared" -ForegroundColor Green

$adsearchobj = New-Object Microsoft.SharePoint.Administration.SPPeoplePickerSearchActiveDirectoryDomain
$dn = Read-Host -Prompt "Provide a domain name for the new filter. Example ms.bgnet.de"
$adsearchobj.DomainName = $dn
$sdn = Read-Host -Prompt "Provide the short domain name for the new filter. Example MS"
$adsearchobj.ShortDomainName = $sdn
$adsearchobj.IsForest = $true
Write-Host "Setting new people picker filter to allow all domain users, to be selected." -ForegroundColor Yellow
$wa1.PeoplePickerSettings.SearchActiveDirectoryDomains.Add($adsearchobj)
$wa1.Update()
Write-Host "Done resetting" -ForegroundColor Green
Read-Host -Prompt "Now assign the alien user to the tenant. Once done hit ENTER or confirm to continue with the procedure"

Write-Host "Re-clearing the PeoplePicker filter" -ForegroundColor Yellow
$wa1.PeoplePickerSettings.SearchActiveDirectoryDomains.Clear()
$wa1.Update()
Write-Host "PeoplePicker filter cleared" -ForegroundColor Green

Write-Host "Re-Setting new people picker filter to allow only tenant users." -ForegroundColor Yellow

$tenantNumber = Read-Host -Prompt "Provide the tenant number. Example 48 for BG-Phoenics"
$tenantGroup = ""
$adsearchobj.CustomFilter = "(&(|((objectCategory=person)(objectClass=user))(objectClass=group))(|(mandantenNr=$($tenantNumber))(cn=UK$($tenantNumber)G-ORG-Alle))(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"
$wa1.PeoplePickerSettings.SearchActiveDirectoryDomains.Add($adsearchobj)
$wa1.Update() 
Write-Host "Done Re-Setting new people picker filter to allow only tenant users." -ForegroundColor Green
