$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

[object[]] $usersWithCerts = Get-ADUser -LDAPFilter '(userCertificate=*)' -Properties userCertificate

Write-Host ('Found user accounts with any certificate: #{0}' -f $usersWithCerts.Length)
foreach ($oneUserWithCert in $usersWithCerts) {

  Write-Host ('One user: {0} | certs = #{1} | {2}' -f $oneUserWithCert.sAMAccountName, $oneUserWithCert.userCertificate.Count, $oneUserWithCert.distinguishedName)

  foreach ($oneCertBin in $oneUserWithCert.userCertificate) {

    $oneCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $oneCert.Import($oneCertBin)

    $isExpired = $oneCert.NotAfter -lt ([DateTime]::Now)
    Write-Host ('  certificate: {0} | expires = {1} (valid = {2}) | usage = {3}' -f $oneCert.Subject, $oneCert.NotAfter.ToString('yyyy-MM-dd HH:mm:ss'), (-not $isExpired), ($oneCert.EnhancedKeyUsageList -join ', '))

    if ($isExpired) {

      $saveExpired = Join-Path $env:TEMP ('expired-cert-{0}-exp{1}-{2}.cer' -f $oneUserWithCert.sAMAccountName, $oneCert.NotAfter.ToString('yyyy-MM-dd-HH-mm-ss'), $oneCert.Thumbprint)
      [void] ([System.IO.File]::WriteAllBytes($saveExpired, $oneCert.Export('Cert')))
      Write-Host ('  removing: saved = {0}' -f $saveExpired)
 
      Set-ADUser -Identity $oneUserWithCert -Certificates @{ Remove = $oneCert }
    }
  }
}
