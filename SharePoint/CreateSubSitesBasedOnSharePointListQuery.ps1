############################################################################################################################################ 
# This script allows to do a CAML query against a list / document library in a SharePoint Site 
# Required Parameters:  
#    ->$sSiteCollection: Site Collection where we want to do the CAML Query 
#    ->$sListName: Name of the list we want to query 
############################################################################################################################################
Clear-Host
 
If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue))  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell } 
 
### Init parameters ###
$Template="BLANKINTERNET#0" ### Publishing site
$Language = 1031 ### German
$sSiteCollection="https://bgp.dev02.sp.ppro.bgnet.de/team/iewibs/" 
$sListName="Projektraumanträge"
$logfile = "L:\TimerLogs\subSiteCreation.log"
$logEntry = [pscustomobject]@{errorMessage="";errorStatus="";success=$false}

<### Logging ###>
function LogWrite
{
    param($logEntry)    
    $fileExists = Test-Path $logFile
    # Get current date
    $dateNow = Get-Date -Format "dd.MM.yyyy HH:mm" 
    # Setup line for logfile
    $fileInp = $dateNow + ' | ' + $logEntry.errorStatus + ' | ' + $logEntry.errorMessage 
    # Test ob die Datei existiert
    If ($fileExists -eq $False)
    {
        # Create log file if it doesn't exist
        $newLogFile = New-Item $logfile -ItemType File
    } 
    # Write to log file
    Add-Content $logfile -value $FileInp
}


<### Create a sub site ###> 
function CreateSubSite
{
    param($subSite)
    ### Init values ###
    $toReturn = $logEntry
    $foundError = $true
    
    ### Start creation logic ###        
    Try{    
        $newSpWeb = New-SPWeb $subSite.url -Template $subSite.template -Name $subSite.title -Description $subSite.description -AddToTopNav -Language $subSite.language -UseParentTopNav -Confirm:$false -ErrorAction Stop;
        $foundError=$false
    }
    Catch{
        $toReturn.errorMessage = $_.Exception.Message
        $toReturn.success = $false
        $toReturn.errorStatus = "Error"
        $foundError = $true
    }

    if(!$foundError){
        ### Enable/Disable feature ###
        Disable-SPFeature -Identity "MDSFeature" -Url $subSite.url -Force -Confirm:$false -ErrorAction Ignore;  # Disable minimum download strategy feature
        $toReturn.errorMessage = "Sub site "+$subSite.url+" erstellt"
        $toReturn.success = $true
        $toReturn.errorStatus = "Success"
    
    }
    
    return $toReturn   


}
 
<### Initiate sub site creation ###>
function CreateSubSites 
{ 
    param ($sSiteCollection,$sListName)
    ### init parameters ###
    $foundError = $true
    $systemMessage = ""
    $systemStatus = ""

    try 
    { 
        $spSite=Get-SPSite -Identity $sSiteCollection -ErrorAction Stop
        $spwWeb=$spSite.OpenWeb()         
        $splList = $spwWeb.Lists.TryGetList($sListName)  
        if ($splList)  
        {  
            $spqQuery = New-Object Microsoft.SharePoint.SPQuery 
            <# Get all approved requests that haven't been processed yet. #>
            $spqQuery.Query ="
                    <Where>
                        <Eq>
                            <FieldRef Name='ProjektraumStatus' />
                            <Value Type='Text'>In Erstellung</Value>
                        </Eq>
                    </Where>
                "

            $splListItems = $splList.GetItems($spqQuery) 
 
            foreach ($splListItem in $splListItems) 
            { 
                <# Create a sub site object #>
                $subSite = [pscustomobject]@{
                    template=$Template;
                    language=$Language;
                    url=$splListItem["ProjektraumURL"];
                    title=$splListItem["Title"];
                    description=$splListItem["ProjektraumBeschreibung"]
                }

                <# Start creating the new teamroom #>
                $newSubSite = CreateSubSite -subSite $subSite -ErrorAction Stop

                if($newSubSite.success){                    
                    $systemMessage = $newSubSite.errorMessage
                    $systemStatus = "Erstellt"
                    LogWrite -logEntry $newSubSite
                
                }else{
                    $systemMessage = $newSubSite.errorMessage
                    $systemStatus = "Fehlgeschlagen"
                    LogWrite -logEntry $newSubSite
                }

                <# Once done update the list #>
                $splListItem["ProjektraumStatus"] = $systemStatus
                $splListItem["ProjektraumSystemmeldung"] = $systemMessage
                $splListItem.Update()                

            } 
        }else{
            $logEntry.errorMessage = "List '" + $sListName + "' not found"
            $logEntry.errorStatus = "Error"
            $logEntry.success = $false
            LogWrite -logEntry $logEntry         
        }      
        $spSite.Dispose() 
    } 
    catch [System.Exception] 
    { 
        $logEntry.errorMessage = $_.Exception.ToString()
        $logEntry.errorStatus = "Error"
        $logEntry.success = $false
        LogWrite -logEntry $logEntry 
    } 
}

 
Start-SPAssignment -Global 


CreateSubSites -sSiteCollection $sSiteCollection -sListName $sListName 

Stop-SPAssignment -Global 
 
Remove-PSSnapin Microsoft.SharePoint.PowerShell