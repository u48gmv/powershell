﻿Clear-Host
$URL = "https://kntk.prod.notes-phas.ppro.bgnet.de/api/ADQuery?adOrgUnit=OU=BG-Phoenics,OU=Benutzer,DC=ms,DC=bgnet,DC=de&adFilter=(%26(objectCategory=person)(sAMAccountName=u*)(!sAMAccountName=u480*))&adAttributes=addFunction;company;companyExt;department;departmentNumber;Division;expertise;expertiseNumber;facsimileTelephoneNumber;floorLevel;functionNumber;givenName;infoExt;initials;ipPhone;l;mail;mailExt;mobile;otherDepartment;otherDepartmentNumber;otherDivision;otherExpertise;otherExpertiseNumber;otherFacsimileTelephone;otherFunctionNumber;otherL;otherPhone;otherPostalCode;otherStreetAddress;otherTeam;otherWorkFunction;postalCode;roomNumber;salutation;sAMAccountName;sn;specFunction;streetAddress;team;telephoneNumber;title;workFunction;memberOf";
<#
$strUser = 'ms\u48gmv';
[System.Security.SecureString]$strPass = ConvertTo-SecureString -String "Admin-600" -AsPlainText -Force;
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($strUser, $strPass);
#>
#$response = Invoke-Webrequest -uri $URL -credential $cred;
$response = Invoke-Webrequest -uri $URL -UseDefaultCredentials;
$response.Content | Out-File -FilePath .\test.json;  #"\\bg48fs-mue10.ms.bgnet.de\batchverarbeitung\organigramm\memberdata.json";

