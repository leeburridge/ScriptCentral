Get-WmiObject -Class Win32_NetworkAdapter -Filter "AdapterType like '%802.3'" | 
%{ 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "Index=$($_.DeviceId)" | Select-Object Description,IPConnectionMetric 
} 
$INTERFACES=wmic nic get NetConnectionID 
 
$INTERFACES|%{ 
if ($_ -like '區域連線*' -or $_ -like 'Local Area Connection*') 
    { 
    $N=$_.trim() 
    $ExParm='netsh interface ip set interface interface="'+"$N"+'"  metric =10' 
    Write-Host $ExParm 
    Invoke-Expression $ExParm  
    } 
elseif ($_ -match '無線網路連線*' -or $_ -like 'Wireless Network Connection*') 
    { 
    $N=$_.trim() 
    $ExParm='netsh interface ip set interface interface="'+"$N"+'"  metric =50' 
    Write-Host $ExParm 
    Invoke-Expression $ExParm 
    } 
} 
 
Write-Host  '                                                                             ' 
Write-Host  ---------------------------- New Connection Metic ----------------------------  
Write-Host  '                                                                             ' 
 
Get-WmiObject -Class Win32_NetworkAdapter -Filter "AdapterType like '%802.3'" | 
%{ 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "Index=$($_.DeviceId)" | Select-Object Description,IPConnectionMetric 
} 
