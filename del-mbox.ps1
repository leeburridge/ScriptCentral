Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session

Remove-Mailbox -Identity "Walter Harp"
Remove-MsolUser -UserPrincipalName <Walter Harp> -RemoveFromRecycleBin true
