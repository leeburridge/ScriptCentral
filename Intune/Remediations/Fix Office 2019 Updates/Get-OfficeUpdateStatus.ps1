$item = get-itempropertyvalue 'HKLM:\Software\Policies\Microsoft\office\16.0\common\officeupdate' 'updatebranch'

if ($item -eq '') {
	Write-Output "Compliant"
	Exit 0
} else {
	Write-Warning "Not Compliant"
	Exit 1
}
