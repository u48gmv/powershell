############################################################################################################################################ 
# This script allows to do a CAML query against a list / document library in a SharePoint Site 
# Required Parameters:  
#    ->$sSiteCollection: Site Collection where we want to do the CAML Query 
#    ->$sListName: Name of the list we want to query 
############################################################################################################################################
Clear-Host 
 
<# Load SharePoint PowerShell if not present #>
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue } 
 
$host.Runspace.ThreadOptions = "ReuseThread" 
 
#Definition of the function that allows to do the CAML query 
function DoCAMLQuery 
{ 
    param ($sSiteCollection,$sListName) 
    try 
    { 
        $spSite=Get-SPSite -Identity $sSiteCollection 
        $spwWeb=$spSite.OpenWeb()         
        $splList = $spwWeb.Lists.TryGetList($sListName)  
        if ($splList)  
        {  
            $spqQuery = New-Object Microsoft.SharePoint.SPQuery 
            <# Get all approved requests that haven't been processed yet. #>
            $spqQuery.Query ="
                <Where>
                    <And>
                        <Eq>
                            <FieldRef Name='ProjektraumGenehmigung' />
                            <Value Type='Text'>Genehmigt</Value>
                        </Eq>
                        <Eq>
                            <FieldRef Name='ProjektraumStatus' />
                            <Value Type='Text'>In Erstellung</Value>
                        </Eq>
                    </And>
                </Where>
                "

            $splListItems = $splList.GetItems($spqQuery) 
 
            foreach ($splListItem in $splListItems) 
            { 
                <# Start creating the new teamroom #>
                $splListItem["ProjektraumStatus"] = "Erstellt"
                $splListItem["ProjektraumSystemmeldung"] = "Raum wurde erfolgreich erstellt"
                $splListItem.Update()                

            } 
        }      
        $spSite.Dispose() 
    } 
    catch [System.Exception] 
    { 
        write-host -f red $_.Exception.ToString() 
    } 
} 
Start-SPAssignment -Global 
#Calling the function 
$sSiteCollection="https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs/" 
$sListName="Projektraumantr�ge" 
DoCamlQuery -sSiteCollection $sSiteCollection -sListName $sListName 
Stop-SPAssignment -Global 
 
#Remove-PSSnapin Microsoft.SharePoint.PowerShell