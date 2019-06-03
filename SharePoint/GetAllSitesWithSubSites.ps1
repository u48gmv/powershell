<############################################################################################################################################ 
# 
# This script gets all sites including the subsites of a web application.
# It will then post the sites and sub sites to a list.
#
# NOTE: The user that executes the scripts needs to have at least write permission to the provided list.
# And needs to be a Farm administrator
#
# Version: 0.0.1
# Author: George Michael Mavridis
# E-Mail: george-michael.mavridis@bg-phoenics.de
# 
############################################################################################################################################>

Clear-Host

If ((Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 


<### Init parameters ###>
$webApp="http://dev02.sp.ppro.bgnet.de/";
$sSiteCollection="https://ssp.dev02.sp.ppro.bgnet.de";
$sListUrl="Lists/sites";


<# Create login credentials #>
$pwd = 'Dj3mrc8-vJCY';
$uname = 'sp48spsetupdev02';
$PasswordAsSecure = ConvertTo-SecureString $pwd -AsPlainText -Force;
$Credentials = New-Object System.Management.Automation.PSCredential ($uname , $PasswordAsSecure);

<### Collect all sites and webs ###>
$webs = get-spwebapplication $webApp | get-spsite -Limit All | get-spweb -Limit All | Select Title, URL, ID, ParentWebID;


<### Connect to the site containig the list to post the results to ###>
$w = Get-SPWeb -Identity $sSiteCollection;
$list = $w.GetList($sListUrl); 


<### Iterate through the webs and add them to the list ###>
foreach ($web in $webs){
    $newItem = $list.AddItem();
    $newitem["Title"] = $web.Title;
    $newitem["url"] = $web.Url;
    $newitem["webid"] = $web.ID;
    $newitem.update()    
    Write-Host "Following site added:" $web.Url;
}



<### Remove snapin and close connection ###>
Remove-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue;
$w.Dispose();

<### Delete items. No recycle-bin
$web = get-spweb "Site URL"
$list = $web.lists["Library Title"]
$query = New-Object Microsoft.SharePoint.SPQuery
$query.ViewAttributes = "Scope='Recursive'"
$query.RowLimit = 1000
$query.ViewFields = "<FieldRef Name='ID'/>"
$query.ViewFieldsOnly = $true
do
{
   $listItems = $list.GetItems($query)
   $query.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
   foreach($item in $listItems)
   {
     Write-Host "Deleting Item - $($item.Id)"
     $list.GetItemById($item.Id).delete()
   }
}
while ($query.ListItemCollectionPosition -ne $null) 
###>

<### List item creation SharePoin Powershell
$web = Get-SPWeb -Identity $webUrl
 $list = $web.Lists[$listname]
 $newItem = $list.AddItem()
 $newitem["Title"] = $a
 $newitem["Custom_Column1"] = $b
 $newitem["Custom_Column2"] = $c
 $newitem.update()
###>