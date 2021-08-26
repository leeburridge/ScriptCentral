# Get-GracePeriod.ps1 (C)2021 Lee Burridge
# Script reads RDS grace perdiod and notifies by email if less than $global:expdays

# Instructions
# Replace $EmailTo with your email address
# Change $global:expdays to how many days the threshold is for reporting a CRL is going to expire
# Debug switch is only used for interactive running (Possible values are 0,1,2)

$debugswitch = 1

$global:expdays = 2
$global:hostname = [System.Net.Dns]::GetHostName()

write-host "Get-GracePeriod v1.0 (C)2021 Lee Burridge"
write-host "Days to check for expiry of grace period :" $global:expdays

$global:Client = $args[0]

write-host "Host : " $global:hostname

$daysleft = (Invoke-WmiMethod -PATH (gwmi -namespace root\cimv2\terminalservices -class win32_terminalservicesetting).__PATH -name GetGracePeriodDays).daysleft

if ($daysleft -lt $global:expdays) {
	$User = "monitor@digitalsaviour.co.uk"
	$File = "C:\scripts\emailpass.txt"


	$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

	$sendto = "monitor" + $global:Client + "@digitalsaviour.co.uk"
	write-host "Sending from : "$sendto

	$EmailFrom = "monitor" + $global:Client + "@digitalsaviour.co.uk"

	$EmailTo = "lburridge@centrality.com"
		$Body = "Expiry of grace period in : " + $daysleft + " days for " + $global:hostname
		
		$Subject = "Grace Period EXCEPTION " + $currentTime + " " + $global:hostname
		
		$SMTPServer = "mail.digitalsaviour.co.uk" 
		$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
		$SMTPMessage.IsBodyHtml = $true
		$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
		$SMTPClient.EnableSsl = $true 
		$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($cred.UserName, $cred.Password); 
		$SMTPClient.Send($SMTPMessage)
		if ($debugswitch = 2) {
			Write-Host "Completed and sent email to $EmailTo"
			$SMTPMessage > email.txt
		}
	}



