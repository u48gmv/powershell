###########################
##### Set init values #####
###########################

$proxy=$true

##################################
##### Proxy settings #############
##### Only needed in case ######## 
##### you are behind a proxy #####
##################################
if($proxy){
    $proxString = "http://10.48.201.38:8080"
    $proxyUri = [System.Uri]::new($proxString)
    [System.Net.WebRequest]::DefaultWebProxy = new-object System.Net.WebProxy ($proxyUri, $true)
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
}

