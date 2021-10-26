param ($company)

write-host -foregroundcolor darkgreen "Get-IntuneDevicesFormatted"

if ($company -eq $null){
  echo "Usage : Get-IntuneDevicesFormatter.ps1 -company <name of company>"
  exit 1
}

$outfile = $company + "-" + (get-date).ToString("M") + ".csv"


set-executionpolicy -executionpolicy bypass
import-module microsoft.graph.intune
connect-msgraph -adminconsent

get-IntuneManagedDevice | select deviceName, lastSyncDateTime, enrolledDateTime, complianceState, operatingSystem, osVersion, serialNumber, manufacturer, model, userDisplayName | export-csv $outfile

echo "Output to $outfile"

exit 0
