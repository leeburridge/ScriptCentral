# Script to change reg key to allow print drivers to be installed from a print server without the user being an administrator

$test = test-path -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\'

if (-not($test)) {
	new-item -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\'
}

$test2 = test-path -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint\'

if (-not($test2)) {
	new-item -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint'
}

New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint' -Name 'RestrictDriverInstallationToAdministrators' -PropertyType DWORD -Value 0 -Force
