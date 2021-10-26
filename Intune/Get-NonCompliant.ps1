Install-Module -Name Microsoft.Graph.Intune
Connect-MSGraph -AdminConsent

# Run this to get non compliant devices and reasons

#Show how many enrolled devices there are
Get-IntuneManagedDeviceOverview | select-object -property enrolledDeviceCount

# Display active devices (Since a certain date)
active = Get-IntuneManagedDevice | Where-Object { $_.lastSyncDateTime -gt "10/1/2021 0:00:01 AM" }
$active.count

# Noncompliant count
$noncompliant = Get-IntuneManagedDevice -Filter "complianceState eq 'noncompliant'" | select-object -property managedDeviceOwnerType,complianceState,deviceName,serialNumber,lastSyncDateTime,osVersion,manufacturer,model,userPrincipalName,userDisplayName
$noncompliant.count

# Compliant count
$compliant = Get-IntuneManagedDevice -Filter "complianceState eq 'compliant'" | select-object -property managedDeviceOwnerType,complianceState,deviceName,serialNumber,lastSyncDateTime,osVersion,manufacturer,model,userPrincipalName,userDisplayName
$compliant.count

############################################## Junk notes
# List all non compliant devices registered into Intune
Get-IntuneManagedDevice -Filter "complianceState eq 'noncompliant'" | select-object -property managedDeviceOwnerType,complianceState,deviceName,serialNumber,lastSyncDateTime,osVersion,manufacturer,model,userPrincipalName,userDisplayName

# Get the policy ID
$polID = Get-IntuneDeviceCompliancePolicy -filter "displayname eq 'CPD: Device Compliance Policy'" | select-object -ExpandProperty id

# Get all policies and their status
Get-IntuneDeviceCompliancePolicyDeviceSettingStateSummary

# Get summary of compliance
Get-IntuneDeviceCompliancePolicyDeviceStateSummary

# Get the Intune policy
Get-IntuneDeviceConfigurationPolicy

# 
$polID = Get-IntuneDeviceCompliancePolicy -filter "displayname eq '##GROUP##'" | select-object -ExpandProperty id
Get-IntuneDeviceCompliancePolicyDeviceStatus -deviceCompliancePolicyId "$polID" -Filter {status -ne "compliant"}
