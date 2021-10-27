Install-Module -Name Microsoft.Graph.Intune
Connect-MSGraph -AdminConsent

# Run this to get non compliant devices and reasons (Excludes VMs)

# Show how many enrolled devices there are
$enroled = Get-IntuneManagedDeviceOverview | select-object -property enrolledDeviceCount
write-host "- $Enroled -"

# Display active devices (Since a certain date)
$active = Get-IntuneManagedDevice | Where-Object { $_.lastSyncDateTime -gt "10/1/2021 0:00:01 AM" } | Where-Object { $_.model -ne "Virtual Machine" }
echo "Active :"
$active.count

# Noncompliant count
$noncompliant = Get-IntuneManagedDevice -Filter "complianceState eq 'noncompliant'" | select-object -property managedDeviceOwnerType,complianceState,deviceName,serialNumber,lastSyncDateTime,osVersion,manufacturer,model,userPrincipalName,userDisplayName | Where-Object { $_.model -ne "Virtual Machine" }
echo "Non compliant :"
$noncompliant.count

# Compliant count
$compliant = Get-IntuneManagedDevice -Filter "complianceState eq 'compliant'" | select-object -property managedDeviceOwnerType,complianceState,deviceName,serialNumber,lastSyncDateTime,osVersion,manufacturer,model,userPrincipalName,userDisplayName | Where-Object { $_.model -ne "Virtual Machine" }
echo "Compliant :"
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
