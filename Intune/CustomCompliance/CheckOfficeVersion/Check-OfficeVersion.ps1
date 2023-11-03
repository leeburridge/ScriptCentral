$OfficeVer = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration' ` | Select-Object -ExpandProperty VersionToReport

$hash =  @{ OfficeVersion = $OfficeVer }

Return $hash | ConvertTo-Json $hash