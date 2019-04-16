Clear-Host
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

function Remove-SPFeatureFromContentDB($ContentDb, $FeatureId, [switch]$ReportOnly)
{
    $db = Get-SPDatabase | where { $_.Name -eq $ContentDb }
    [bool]$report = $false
    if ($ReportOnly) { $report = $true }
    
    $db.Sites | ForEach-Object {
        
        Remove-SPFeature -obj $_ -objName "site collection" -featId $FeatureId -report $report
        write-host $_ -ForegroundColor Cyan
                
        $_ | Get-SPWeb -Limit all | ForEach-Object {
            
            Remove-SPFeature -obj $_ -objName "site" -featId $FeatureId -report $report
        }
    }
}

function Remove-SPFeature($obj, $objName, $featId, [bool]$report)
{
    $feature = $obj.Features[$featId]
    
    if ($feature -ne $null) {
        if ($report) {
            write-host "Feature found in" $objName ":" $obj.Url -foregroundcolor Red
        }
        else
        {
            try {
                $obj.Features.Remove($feature.DefinitionId, $true)
                write-host "Feature successfully removed from" $objName ":" $obj.Url -foregroundcolor Red
            }
            catch {
                write-host "There has been an error trying to remove the feature:" $_
            }
        }
    }
    else {
        #write-host "Feature ID specified does not exist in" $objName ":" $obj.Url
    }
}

$featureId = "6e6bc9ae-643f-42e5-8db4-527bc7951267"
$contentDB = "WSS_Content"

#Remove-SPFeatureFromContentDB -ContentDB $contentDB -FeatureId $featureId –ReportOnly

Remove-SPFeatureFromContentDB -ContentDB $contentDB -FeatureId $featureId