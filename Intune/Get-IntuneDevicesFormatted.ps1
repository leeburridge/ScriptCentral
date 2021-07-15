$tenant = "a31f2452-5c8f-426a-8bb1-432d7ddc65a7"
$authority = "https://login.windows.net/$tenant"
$clientId = "b8ac7218-3f2f-4bdf-b738-226a8cd8ad47"
$Thumbprint = "4f8d9229b16c265b7924652056c2bdfdfc842ffe"

Update-MSGraphEnvironment -AppId $clientId -Quiet
Update-MSGraphEnvironment -AuthUrl $authority -Quiet
Connect-MSGraph -CertificateThumbprint $Thumbprint

get-IntuneManagedDevice | select deviceName, lastSyncDateTime, enrolledDateTime, complianceState, operatingSystem, osVersion, serialNumber, userDisplayName, manufacturer, model | export-csv devices.csv
