# Name : Check-DeviceCompliance.ps1
# Author : Lee Burridge
# Date : 6th April 2023

# Read in devices.csv which contains a bare list of device names and go through one by one checking
# device compliance. Data is outputed in a dated file so it's easy for running daily and checking history.

# Check if the Microsoft.graph.intune Powershell module is already installed and if not, install it.
if (Get-Module -ListAvailable -Name microsoft.graph.intune) {
	Write-Host "microsoft.graph.intune PowerShell Module already installed"
}
else {
	Write-Host "microsoft.graph.intune PowerShell Module not found. Installing"
	install-module msgraph -force
}

# Authenticate to MSGraph so that we can check
Connect-MSGraph

$date = Get-Date -format "yyyyMMdd"
start-transcript "$date.txt"
$csv = Import-Csv -Path "devices.csv"
ac -path "$date.csv" -value "Device, Status"
$i = 1
foreach ($device in $csv) {
    $deviceName = $device.DeviceName
    $complianceStatus = (Get-IntuneManagedDevice -Filter "DeviceName eq '$deviceName'").ComplianceState
    Write-Host "$deviceName : $complianceStatus"
    ac -path "$date.csv" -value "$devicename, $complianceStatus"
	if ($complianceStatus -eq "compliant") { $i++ }
}

# Output the number of compliant devices from the list
write-output "Total Compliant : $i"
stop-transcript
