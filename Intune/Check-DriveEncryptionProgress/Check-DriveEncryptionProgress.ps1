$EncryptionPercent = Get-BitLockerVolume -mountpoint "c:"
$percent = $EncryptionPercent.encryptionpercentage

# $EncryptionPercent = $EncryptionPercent.EncryptionPercentage

Try {
   if ($percent -like '*100*'){
		return "$($EncryptionPercent.volumestatus) - $($EncryptionPercent.encryptionpercentage) - $($EncryptionPercent.ProtectionStatus)"
        Exit 0
    } 
    return "$($EncryptionPercent.volumestatus) - $($EncryptionPercent.encryptionpercentage) - $($EncryptionPercent.ProtectionStatus)"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}

