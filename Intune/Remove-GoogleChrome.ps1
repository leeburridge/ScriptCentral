# Script to uninstall Google Chrome. Can be used in Intune to remove if necessary.

$GoogleChrome = [CimInstance](Get-CimInstance -ClassName Win32_Product | Where-Object {$_.Name -eq 'Google Chrome'})
If ($GoogleChrome -ne $null) {
    Write-Host 'Uninstalling Google Chrome'$GoogleChrome.Version
    Invoke-CimMethod -InputObject $GoogleChrome -MethodName 'Uninstall' | Out-Null
}
