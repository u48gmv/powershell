Clear-Host

If ($null -eq (Get-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue) )  
{ Add-PSSnapIn -Name Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue }

<### Init parameters ###>
$webApp="http://dev02.sp.ppro.bgnet.de/";
$sSiteCollection="https://ssp.dev02.sp.ppro.bgnet.de";
$sListUrl="Lists/testlist";


$w = Get-SPWeb -Identity $sSiteCollection;
$list = $w.GetList($sListUrl);
<###
for ($i=0;$i -le 10000;$i++){
    $title = "Item "+$i;
    $newItem = $list.AddItem();
    $newitem["Title"] = $title;
    $newitem.update();    
    Write-Host "Following item added:" $title;
}
##>
$items = $list.Items;
$itemsA = @();

foreach ($item in $items){
    $itemsA += $item.Title;
}

$test = $itemsA -ceq "Item 100002";
if($test){
    Write-Host "Found" $test;
}else{
    Write-Host "Not found" $test;
}


$w.Dispose();
 