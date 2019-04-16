clear-host
$featureToDelete = "ALL.SP.SIPV_ShowSipMessages"
write-host "Deleting $featureToDlete" 
$feature = Get-SPFeature | ?{$_.DisplayName -like "*sip*" }
$feature.Delete()
write-host "Feature $featureToDelete deleted"

