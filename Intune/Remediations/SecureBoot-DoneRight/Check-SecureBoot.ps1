$status = Confirm-SecureBootUEFI
$hash = @{ SecureBoot = "$status" }
return $hash | ConvertTo-Json -Compress
