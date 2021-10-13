Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
import-module az
$subID = "subscription ID"
$resgroup = "Resource Group"
$hostpoolName = "Host Pool Name"
    
Get-AzWvdUserSession -SubscriptionId $SubID -ResourceGroupName $resgroup -HostPoolName $hostpoolName | select Name, UserPrincipalName
