<#
  migratecheck.ps1 (C)2017 Anthony Burridge
  Run this to create a loop and list that will continue to refresh every 30 seconds until all mailbox migrations have finished.
#>
cls
do {
Get-MoveRequest | where {$_status -notlike "complete*"} | Get-MoveRequestStatistics | select DisplayName,status,percentcomplete,itemstransferred
$mr = get-moverequest -movestatus inprogress
start-Sleep -s 30
} until (-not $mr)
