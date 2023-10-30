$BitlockerStatus = Get-BitLockerVolume -mountpoint "c:"
 
$EncryptionPercent = $BitlockerStatus.EncryptionPercentage
$ProtectStatus = $BitlockerStatus.ProtectionStatus
 
Try {
	if ($encryptionpercent -eq '100') {
		if ($protectStatus -eq 'Off') {
			write-output "Encrypted but off"
			Exit 1
		} else {
			write-output "Probably OK - $encryptionpercent - $protectstatus "
		}
    } 
 
    Write-output "$EncryptionPercent - $ProtectStatus - IGNORE!"
    Exit 0
} 
Catch {
    Write-output "Not Compliant"
    Exit 0
}


