# Run this to get non compliant devices and reasons

#Show how many enrolled devices there are
Get-IntuneManagedDeviceOverview | select-object -property enrolledDeviceCount

# List all non compliant devices registered into Intune
Get-IntuneManagedDevice -Filter "complianceState eq 'noncompliant'" | select-object -property deviceName,serialNumber,lastSyncDateTime,osVersion

# Get the policy ID
$polID = Get-IntuneDeviceCompliancePolicy -filter "displayname eq 'CPD: Device Compliance Policy'" | select-object -ExpandProperty id
