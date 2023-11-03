$OfficeVer = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' 

$hash =  @{ OfficeVersion = $OfficeVer.VersionToReport; UpdateChannel = $OfficeVer.UpdateChannel }

Return $hash | ConvertTo-Json -Compress

