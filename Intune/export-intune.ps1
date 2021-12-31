# Export-Intune.ps1
# (C)2021 Lee Burridge
#
# This script will connect to MSGraph and dump some numbers that you may find useful. Two parameters can be passed to the script (The start date (Uses US date format of MM/DD/YYYY) and an 
# identifier. The identifier is the start of the device names that you want to identify as being the ones you want to check out.

write-host "Export-Intune v0.1"
write-host "SYNTAX : ./Export-Intune.ps1 startdate identifier"

if ($args.count -eq 0) {
	write-host "No parameters specified"
	Break Script
}

connect-msgraph

$startdate = $args[0] + ' 00:00:01'
write-host "Start date : $startdate"
$identifier = $args[1]
write-host "Identifier : $identifier"

$devtotal = (Get-IntuneManagedDevice | Get-MSGraphAllPages).count
$devactive = (Get-IntuneManagedDevice | Get-MSGraphAllPages | Where-object { ($_.lastsyncdatetime -gt $startdate) -and ($_.devicename -like $identifier+'*') -and ($_.operatingSystem -eq 'Windows')}).count
$devnoncompliant = (Get-IntuneManagedDevice | Get-MSGraphAllPages | Where-object { ($_.complianceState -eq 'noncompliant') -and ($_.lastsyncdatetime -gt $startdate) -and ($_.devicename -like $identifier+'*') -and ($_.operatingSystem -eq 'Windows')}).count

Write-output "Totals for : $identifier" | Out-File $identifier".txt" -append
Write-output "Total devices : $devtotal" | Out-File $identifier".txt" -append
Write-output "Active Devices : $devactive" | Out-File $identifier".txt" -append
Write-output "Non-compliant : $devnoncompliant" | Out-File $identifier".txt" -append

Get-IntuneManagedDevice | Get-MSGraphAllPages | export-csv "$identifier-all.csv"
Get-IntuneManagedDevice | Get-MSGraphAllPages | Where-object { ($_.lastsyncdatetime -gt $startdate) -and ($_.devicename -like $identifier+'*') -and ($_.operatingSystem -eq 'Windows')} | export-csv "$identifier-active.csv"
Get-IntuneManagedDevice | Get-MSGraphAllPages | Where-object { ($_.complianceState -eq 'noncompliant') -and ($_.lastsyncdatetime -gt $startdate) -and ($_.devicename -like $identifier+'*') -and ($_.operatingSystem -eq 'Windows')} | export-csv "$identifier-active-noncompliant.csv"
