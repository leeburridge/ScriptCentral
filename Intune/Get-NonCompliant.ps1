Install-Module -Name Microsoft.Graph.Intune
Connect-MSGraph -AdminConsent

# Run this to get non compliant devices and reasons

#Show how many enrolled devices there are
Get-IntuneManagedDeviceOverview | select-object -property enrolledDeviceCount

# List all non compliant devices registered into Intune
Get-IntuneManagedDevice -Filter "complianceState eq 'noncompliant'" | select-object -property complianceState,deviceName,serialNumber,lastSyncDateTime,osVersion,manufacturer,model,userPrincipalName,userDisplayName

# Get the policy ID
$polID = Get-IntuneDeviceCompliancePolicy -filter "displayname eq 'CPD: Device Compliance Policy'" | select-object -ExpandProperty id

# Get all policies and their status
Get-IntuneDeviceCompliancePolicyDeviceSettingStateSummary

# Get summary of compliance
Get-IntuneDeviceCompliancePolicyDeviceStateSummary

# Get the Intune policy
Get-IntuneDeviceConfigurationPolicy

# 
$polID = Get-IntuneDeviceCompliancePolicy -filter "displayname eq 'CPD: Device Compliance Policy'" | select-object -ExpandProperty id
Get-IntuneDeviceCompliancePolicyDeviceStatus -deviceCompliancePolicyId "$polID" -Filter {status -ne "compliant"}

