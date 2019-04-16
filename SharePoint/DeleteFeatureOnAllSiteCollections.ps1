Clear-Host
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 
#Feature to Deactivate
$FeatureID="3b2f5e13-ac19-49d1-96f6-f116f915fd16"
 
#Get all Site collections
$SitesColl= Get-SPWebApplication | Get-SPSite -Limit ALL
#Get the Feature
$Feature = Get-SPFeature | Where {$_.ID -eq $FeatureID}
 
#Check if Feature exists
if($Feature -ne $null)
{
    #Iterate through through each site collection and deactivate the feature
    Foreach($Site in $SitesColl)
    {
       #Check if the Feature is activated
       if (Get-SPFeature -Site $Site.Url | Where {$_.ID -eq $FeatureId})
       {
            #DeActivate the Feature
            Disable-SPFeature –identity $FeatureID -URL $Site.URL -Confirm:$false
            Write-Host "Feature has been Deactivated on "$Site.URL -f Green
       }
       else
       {
            Write-host "Feature was not activated on "$Site.URL -f Cyan
       }
    }
}
else   
{
    Write-Host "Feature doesn't exist:"$FeatureID -f Red
}
