## Quickest method to connect to Exchange Online

Set-ExecutionPolicy RemoteSigned

# Close and re-open your PowerShell window when done
Install-Module -Name PowerShellGet -Force

# Add -Force to it when you need to update EXO V1.
Install-Module -Name ExchangeOnlineManagement -Force

(Get-Module -ListAvailable -Name ExchangeOnlineManagement) -ne $null

Connect-ExchangeOnline -UserPrincipalName username@domain.com -ShowProgress $true
