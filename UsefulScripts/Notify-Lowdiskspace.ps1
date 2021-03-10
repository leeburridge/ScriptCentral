# Change variables to be working SMTP creds and the $cname to the PCs name. Much more to be configured in here and needs putting into arguments.

$cname="Mycomputer"
ForEach ($c in $cname)
{
$disk=Get-WmiObject win32_logicaldisk -ComputerName $c -Filter "Drivetype=3" -ErrorAction SilentlyContinue | Where-Object {($_.freespace/$_.size) -le '0.05'}
If ($disk)
{
$EmailToAdd = "test@test.com"
$EmailFromAdd = "test@test.com"
$userdet = 'testuser'
$passworddet = "testpwd"
$Subjectdet = "Disk space alert"
$Bodydet = "low space in the system"
$SMTPServerdet = "testswer"
$SMTPMessagedet = New-Object System.Net.Mail.MailMessage($EmailFromAdd,$EmailToAdd,$Subjectdet,$Bodydet)
$SMTPClientdet = New-Object Net.Mail.SmtpClient($SMTPServerdet, 587)
$ SMTPClientdet.EnableSsl = $true
$ SMTPClientdet.Credentials = New-Object System.Net.NetworkCredential($userdet, $passworddet)
$ SMTPClientdet.Send($SMTPMessagedet)
}
}
